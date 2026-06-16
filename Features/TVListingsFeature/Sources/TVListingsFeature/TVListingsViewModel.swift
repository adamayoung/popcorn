//
//  TVListingsViewModel.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation
import OSLog
import Presentation
import TVListingsDomain

/// A now-playing entry pairing a channel with the programme currently airing on
/// it, plus the programme scheduled to air next (if known).
public struct TVListingsNowPlayingItem: Identifiable, Equatable, Sendable {

    public let channel: Channel
    public let programme: TVProgramme
    public let nextProgramme: TVProgramme?

    public var id: String {
        programme.id
    }

    public init(channel: Channel, programme: TVProgramme, nextProgramme: TVProgramme? = nil) {
        self.channel = channel
        self.programme = programme
        self.nextProgramme = nextProgramme
    }

}

/// The data shown by ``TVListingsView`` once loaded.
public struct TVListingsViewSnapshot: Equatable, Sendable {

    public let items: [TVListingsNowPlayingItem]

    public init(items: [TVListingsNowPlayingItem] = []) {
        self.items = items
    }

}

/// A nation grouping of selectable regions, for the region-filter menu.
public struct TVListingsRegionSection: Identifiable, Equatable, Sendable {

    public let nation: String
    public let regions: [TVRegionGroup]

    public var id: String {
        nation
    }

    public init(nation: String, regions: [TVRegionGroup]) {
        self.nation = nation
        self.regions = regions
    }

}

/// Drives ``TVListingsView``.
///
/// Loading is driven by the view through ``load()`` from a `.task`, so SwiftUI
/// owns the lifetime: the work is cancelled on disappear and restarted on
/// reappear (or when ``reload()`` bumps ``reloadID``). There is deliberately no
/// view-model-owned `Task` — structured concurrency keeps the work tied to the
/// view's lifetime with no manual cancellation.
///
/// Syncing is fully automatic and app-level (see `AppRootViewModel`); this view
/// model only reads the cached listings. It fetches the next day's worth of
/// listings, the channel directory, and the region directory, then shows the
/// programme airing now on each channel **in the selected region**. Changing the
/// region re-filters the already-fetched data in memory (no refetch).
@Observable
@MainActor
public final class TVListingsViewModel {

    public typealias ViewSnapshot = TVListingsViewSnapshot

    private static let logger = Logger.tvListings

    /// Nation order for the region menu; unknown nations fall back to alphabetical, after these.
    private static let nationOrder = ["England", "Scotland", "Wales", "Northern Ireland", "Ireland", "Channel Islands"]

    /// Default region on first launch (coupled to the feed's exact area/nation names).
    private static let defaultAreaName = "London"
    private static let defaultNation = "England"

    public private(set) var viewState: ViewState<ViewSnapshot>

    /// The selectable regions (areas that have channels), grouped by nation, for the filter menu.
    public private(set) var regionsByNation: [TVListingsRegionSection] = []

    /// The region currently filtering the listings, or `nil` when no region data is available.
    public private(set) var selectedRegion: TVRegionGroup?

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry after an error
    /// or to pick up freshly-synced data on foreground.
    public private(set) var reloadID = 0

    private let dependencies: TVListingsDependencies
    private let now: @Sendable () -> Date

    /// Raw fetched data, cached so a region change can re-filter without a refetch.
    private var cachedChannels: [Channel] = []
    private var cachedProgrammes: [TVProgramme] = []

    /// Monotonic id for in-flight ``fetch()`` calls. Only the most recently
    /// started fetch may commit its result, so a slow fetch can't overwrite
    /// fresher listings produced by a concurrent ``refresh()``.
    private var fetchGeneration = 0

    public init(
        dependencies: TVListingsDependencies,
        now: @escaping @Sendable () -> Date = { .now },
        viewState: ViewState<ViewSnapshot> = .initial
    ) {
        self.dependencies = dependencies
        self.now = now
        self.viewState = viewState
    }

    // MARK: - Lifecycle

    /// Fetches the now-playing listings.
    ///
    /// Drive this from the view's `.task(id:)`; SwiftUI cancels it on disappear
    /// and reruns it on reappear / ``reload()``.
    public func load() async {
        await fetch()
    }

    /// Re-reads the cached listings without changing `reloadID`. Use for
    /// pull-to-refresh and to pick up data produced by a background sync.
    public func refresh() async {
        await fetch()
    }

    /// Reruns the view's `.task(id:)` by changing ``reloadID`` — used to retry
    /// after an error and to refresh when the app returns to the foreground.
    public func reload() {
        reloadID += 1
    }

    // MARK: - Region selection

    /// Filters the listings to `group`, persists the choice, and rebuilds the snapshot from the
    /// already-fetched data. Synchronous and never refetches.
    public func selectRegion(_ group: TVRegionGroup) {
        selectedRegion = group
        dependencies.saveSelectedRegionID(group.id)
        rebuildSnapshot()
    }

    // MARK: - Loading

    func fetch() async {
        fetchGeneration += 1
        let generation = fetchGeneration

        if !viewState.isReady {
            viewState = .loading
        }

        do {
            async let channelsTask = dependencies.fetchChannels()
            async let regionsTask = dependencies.fetchRegions()
            async let listingsTask = dependencies.fetchListings()
            let (channels, regions, programmes) = try await (channelsTask, regionsTask, listingsTask)

            // A newer fetch superseded this one — drop the stale result so it
            // can't clobber fresher listings. The first successful result is always
            // allowed to commit (`!viewState.isReady`), so an overlapping refresh
            // that fails can't hide good data behind an error screen.
            guard generation == fetchGeneration || !viewState.isReady else {
                return
            }

            cachedChannels = channels
            cachedProgrammes = programmes

            let available = TVRegionFiltering.groups(from: regions)
                .filter { !TVRegionFiltering.channels(channels, in: $0).isEmpty }
            regionsByNation = Self.sectioned(available)
            selectedRegion = Self.resolveSelection(
                available: available,
                current: selectedRegion,
                persistedID: dependencies.loadSelectedRegionID()
            )

            rebuildSnapshot()
        } catch {
            // Superseded by a newer fetch, or cancelled because the view
            // disappeared: leave the state for the winner / the next `.task` run
            // rather than surfacing a stale error.
            guard generation == fetchGeneration else {
                return
            }
            if Task.isCancelled || error is CancellationError {
                return
            }
            Self.logger.error(
                "Failed loading now-playing TV listings: \(error.localizedDescription, privacy: .public)"
            )
            if !viewState.isReady {
                viewState = .error(ViewStateError(error))
            }
        }
    }

    /// Rebuilds the ready snapshot from cached data, filtered to ``selectedRegion``. When no
    /// region is selected (no region data synced yet) all channels are shown, so the screen
    /// is never empty just because regions are missing.
    private func rebuildSnapshot() {
        let channels = selectedRegion
            .map { TVRegionFiltering.channels(cachedChannels, in: $0) }
            ?? cachedChannels
        let snapshot = ViewSnapshot(
            items: Self.buildNowPlayingItems(channels: channels, programmes: cachedProgrammes, now: now())
        )
        viewState = .ready(snapshot)
    }

    /// Resolves the region to filter by: keep the current one if still available, else the
    /// persisted one, else default to London, else the first England area, else the first
    /// available — or `nil` when there are no regions with channels.
    private static func resolveSelection(
        available: [TVRegionGroup],
        current: TVRegionGroup?,
        persistedID: String?
    ) -> TVRegionGroup? {
        guard !available.isEmpty else {
            return nil
        }
        if let current, let match = available.first(where: { $0.id == current.id }) {
            return match
        }
        if let persistedID, let match = available.first(where: { $0.id == persistedID }) {
            return match
        }
        if let london = available.first(where: { $0.name.caseInsensitiveCompare(defaultAreaName) == .orderedSame }) {
            return london
        }
        if let england = available.first(where: { $0.nation == defaultNation }) {
            return england
        }
        return available.first
    }

    private static func sectioned(_ groups: [TVRegionGroup]) -> [TVListingsRegionSection] {
        let byNation = Dictionary(grouping: groups, by: \.nation)
        let nations = byNation.keys.sorted { lhs, rhs in
            switch (nationOrder.firstIndex(of: lhs), nationOrder.firstIndex(of: rhs)) {
            case (let lhsIndex?, let rhsIndex?):
                lhsIndex < rhsIndex
            case (_?, nil):
                true
            case (nil, _?):
                false
            default:
                lhs.localizedCaseInsensitiveCompare(rhs) == .orderedAscending
            }
        }
        return nations.map { TVListingsRegionSection(nation: $0, regions: byNation[$0] ?? []) }
    }

    /// Selects the programme airing at `now` on each channel from the next day's
    /// listings, preserving the channel order provided by the dependency.
    /// Channels with nothing airing now are omitted.
    private static func buildNowPlayingItems(
        channels: [Channel],
        programmes: [TVProgramme],
        now: Date
    ) -> [TVListingsNowPlayingItem] {
        let programmesByChannelID = Dictionary(grouping: programmes, by: \.channelID)

        return channels.compactMap { channel in
            let programmes = (programmesByChannelID[channel.id] ?? [])
                .sorted { $0.startTime < $1.startTime }
            guard let nowPlaying = programmes.first(where: { $0.startTime <= now && now < $0.endTime }) else {
                return nil
            }
            // The next programme is the soonest one starting at or after the
            // current one ends; nil when the fetched window has nothing after it.
            let nextProgramme = programmes.first { $0.startTime >= nowPlaying.endTime }
            return TVListingsNowPlayingItem(
                channel: channel,
                programme: nowPlaying,
                nextProgramme: nextProgramme
            )
        }
    }

}

#if DEBUG
    public extension TVListingsViewModel {

        /// A view model pinned to a fixed view state with no-op dependencies, for
        /// previews and snapshot tests.
        static func preview(
            viewState: ViewState<ViewSnapshot> = .initial
        ) -> TVListingsViewModel {
            TVListingsViewModel(dependencies: .preview, viewState: viewState)
        }

    }
#endif
