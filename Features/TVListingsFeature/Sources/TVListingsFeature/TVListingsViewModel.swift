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

/// A single programme block in the EPG grid, decorated with the derived state the
/// grid UI needs (airing status, genre, and airing progress).
public struct TVListingsProgrammeItem: Identifiable, Equatable, Sendable {

    public let programme: TVProgramme

    /// `true` when the programme is currently on air (`start <= now < end`).
    public let isAiringNow: Bool

    /// The programme's first genre, or `nil` when it has none.
    public let genre: String?

    /// Fraction of the programme already elapsed, clamped to `0...1`. `0` when the
    /// programme is not currently airing.
    public let progress: Double

    public var id: String {
        programme.id
    }

    public init(programme: TVProgramme, isAiringNow: Bool, genre: String?, progress: Double) {
        self.programme = programme
        self.isAiringNow = isAiringNow
        self.genre = genre
        self.progress = progress
    }

}

/// A single channel row in the EPG grid, pairing a channel with its ordered
/// programmes. `programmes` may be empty when the channel has no listings.
public struct TVListingsChannelRow: Identifiable, Equatable, Sendable {

    public let channel: TVChannel

    /// The channel's programmes, ordered by `startTime`. May be empty.
    public let programmes: [TVListingsProgrammeItem]

    public var id: String {
        channel.id
    }

    public init(channel: TVChannel, programmes: [TVListingsProgrammeItem]) {
        self.channel = channel
        self.programmes = programmes
    }

}

/// The EPG grid data shown by ``TVListingsView`` once loaded.
public struct TVListingsGridSnapshot: Equatable, Sendable {

    public let rows: [TVListingsChannelRow]

    /// The timeline geometry mapping programme times onto the horizontal axis.
    public let geometry: TimelineGeometry

    /// The reference time the snapshot was built for (used for the "now" indicator
    /// and airing/progress calculations).
    public let now: Date

    public init(rows: [TVListingsChannelRow], geometry: TimelineGeometry, now: Date) {
        self.rows = rows
        self.geometry = geometry
        self.now = now
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
/// model only reads the cached listings. ``refresh()`` re-reads the cache so the
/// view can pick up data produced by a background sync (e.g. on foreground).
@Observable
@MainActor
public final class TVListingsViewModel {

    public typealias ViewSnapshot = TVListingsGridSnapshot

    private static let logger = Logger.tvListings

    public private(set) var viewState: ViewState<ViewSnapshot>

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry after an error
    /// or to pick up freshly-synced data on foreground.
    public private(set) var reloadID = 0

    private let dependencies: TVListingsDependencies

    /// Supplies the reference time used to stamp the snapshot. Injectable so tests
    /// can pin airing/progress calculations to a fixed instant.
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
            async let programmesTask = dependencies.fetchListings()
            let (channels, programmes) = try await (channelsTask, programmesTask)

            // A newer fetch superseded this one — drop the stale result so it
            // can't clobber fresher listings.
            guard generation == fetchGeneration else {
                return
            }

            let snapshot = Self.buildSnapshot(channels: channels, programmes: programmes, now: now())
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

    static func buildSnapshot(
        channels: [TVChannel],
        programmes: [TVProgramme],
        now: Date
    ) -> ViewSnapshot {
        let programmesByChannelID = Dictionary(grouping: programmes, by: \.channelID)

        // One row per channel, in channel order. Channels with no programmes still
        // yield a row (empty `programmes`); programmes with no matching channel are
        // dropped as orphans.
        let rows = channels.map { channel -> TVListingsChannelRow in
            let items = (programmesByChannelID[channel.id] ?? [])
                .sorted { $0.startTime < $1.startTime }
                .map { Self.makeItem(programme: $0, now: now) }
            return TVListingsChannelRow(channel: channel, programmes: items)
        }

        return ViewSnapshot(
            rows: rows,
            geometry: TimelineGeometry.flooringNow(now),
            now: now
        )
    }

    private static func makeItem(programme: TVProgramme, now: Date) -> TVListingsProgrammeItem {
        let isAiringNow = programme.startTime <= now && now < programme.endTime
        let progress: Double = {
            guard isAiringNow, programme.duration > 0 else {
                return 0
            }
            let elapsed = now.timeIntervalSince(programme.startTime)
            return min(1, max(0, elapsed / programme.duration))
        }()

        return TVListingsProgrammeItem(
            programme: programme,
            isAiringNow: isAiringNow,
            genre: programme.genres.first,
            progress: progress
        )
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
