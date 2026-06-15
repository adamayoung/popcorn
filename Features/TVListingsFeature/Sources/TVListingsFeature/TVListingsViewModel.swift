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

    public let channel: TVChannel
    public let programme: TVProgramme
    public let nextProgramme: TVProgramme?

    public var id: String {
        programme.id
    }

    public init(channel: TVChannel, programme: TVProgramme, nextProgramme: TVProgramme? = nil) {
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
/// listings via ``TVListingsDependencies/fetchListings`` and selects the
/// programme airing now on each channel. ``refresh()`` re-reads the cache so the
/// view can pick up data produced by a background sync (e.g. on foreground).
@Observable
@MainActor
public final class TVListingsViewModel {

    public typealias ViewSnapshot = TVListingsViewSnapshot

    private static let logger = Logger.tvListings

    public private(set) var viewState: ViewState<ViewSnapshot>

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry after an error
    /// or to pick up freshly-synced data on foreground.
    public private(set) var reloadID = 0

    private let dependencies: TVListingsDependencies
    private let now: @Sendable () -> Date

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

    // MARK: - Loading

    func fetch() async {
        fetchGeneration += 1
        let generation = fetchGeneration

        if !viewState.isReady {
            viewState = .loading
        }

        do {
            async let channelsTask = dependencies.fetchChannels()
            async let listingsTask = dependencies.fetchListings()
            let (channels, programmes) = try await (channelsTask, listingsTask)

            // A newer fetch superseded this one — drop the stale result so it
            // can't clobber fresher listings.
            guard generation == fetchGeneration else {
                return
            }

            let snapshot = ViewSnapshot(
                items: Self.buildNowPlayingItems(channels: channels, programmes: programmes, now: now())
            )
            viewState = .ready(snapshot)
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

    /// Selects the programme airing at `now` on each channel from the next day's
    /// listings, preserving the channel order provided by the dependency.
    /// Channels with nothing airing now are omitted.
    private static func buildNowPlayingItems(
        channels: [TVChannel],
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
