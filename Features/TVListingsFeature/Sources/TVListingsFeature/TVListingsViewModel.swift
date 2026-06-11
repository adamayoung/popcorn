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

/// A now-playing entry pairing a channel with the programme currently airing on it.
public struct TVListingsNowPlayingItem: Identifiable, Equatable, Sendable {

    public let channel: TVChannel
    public let programme: TVProgramme

    public var id: String {
        programme.id
    }

    public init(channel: TVChannel, programme: TVProgramme) {
        self.channel = channel
        self.programme = programme
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
/// model only reads the cached listings. ``refresh()`` re-reads the cache so the
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

    /// Monotonic id for in-flight ``fetch()`` calls. Only the most recently
    /// started fetch may commit its result, so a slow fetch can't overwrite
    /// fresher listings produced by a concurrent ``refresh()``.
    private var fetchGeneration = 0

    public init(
        dependencies: TVListingsDependencies,
        viewState: ViewState<ViewSnapshot> = .initial
    ) {
        self.dependencies = dependencies
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
            async let programmesTask = dependencies.fetchNowPlayingProgrammes()
            let (channels, programmes) = try await (channelsTask, programmesTask)

            // A newer fetch superseded this one — drop the stale result so it
            // can't clobber fresher listings.
            guard generation == fetchGeneration else {
                return
            }

            let snapshot = ViewSnapshot(items: Self.buildItems(channels: channels, programmes: programmes))
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

    private static func buildItems(
        channels: [TVChannel],
        programmes: [TVProgramme]
    ) -> [TVListingsNowPlayingItem] {
        let programmesByChannelID = Dictionary(grouping: programmes, by: \.channelID)

        // The order of the `channels` array from the dependency is preserved as-is; programmes
        // with no matching channel are dropped.
        return channels.flatMap { channel in
            (programmesByChannelID[channel.id] ?? []).map { programme in
                TVListingsNowPlayingItem(channel: channel, programme: programme)
            }
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
