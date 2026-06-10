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
import TVListingsApplication
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
/// The manual refresh ``sync()`` is guarded by ``isSyncing``: the sync button is
/// disabled while a sync is in flight, so a plain guarded async method is correct
/// — no cancellation or stored task is needed.
@Observable
@MainActor
public final class TVListingsViewModel {

    public typealias ViewSnapshot = TVListingsViewSnapshot

    /// The kind of failure surfaced by a manual ``sync()``.
    public enum ErrorKind: Equatable, Sendable {
        case network
        case local
        case unknown
    }

    private static let logger = Logger.tvListings

    public private(set) var viewState: ViewState<ViewSnapshot>
    public private(set) var isSyncing: Bool
    public private(set) var lastSyncErrorKind: ErrorKind?

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry after an error.
    public private(set) var reloadID = 0

    private let dependencies: TVListingsDependencies

    /// Monotonic id for in-flight ``fetch()`` calls. Only the most recently
    /// started fetch may commit its result, so a slow initial fetch can't
    /// overwrite fresher listings produced by a concurrent ``sync()`` →
    /// ``fetch()`` (the MVVM equivalent of the reducer's `cancelInFlight: true`).
    private var fetchGeneration = 0

    public init(
        dependencies: TVListingsDependencies,
        viewState: ViewState<ViewSnapshot> = .initial,
        isSyncing: Bool = false,
        lastSyncErrorKind: ErrorKind? = nil
    ) {
        self.dependencies = dependencies
        self.viewState = viewState
        self.isSyncing = isSyncing
        self.lastSyncErrorKind = lastSyncErrorKind
    }

    // MARK: - Lifecycle

    /// Fetches the now-playing listings.
    ///
    /// Drive this from the view's `.task(id:)`; SwiftUI cancels it on disappear
    /// and reruns it on reappear / ``reload()``.
    public func load() async {
        await fetch()
    }

    /// Retries loading after an error by changing ``reloadID``, which reruns the
    /// view's `.task(id:)`.
    public func reload() {
        reloadID += 1
    }

    public func dismissSyncError() {
        lastSyncErrorKind = nil
    }

    // MARK: - Sync

    /// Refreshes the local cache from the remote EPG feed, then reloads the
    /// listings. A no-op while a sync is already in flight.
    public func sync() async {
        guard !isSyncing else {
            return
        }

        isSyncing = true
        lastSyncErrorKind = nil

        Self.logger.info("Starting TV listings sync")
        do {
            try await dependencies.sync()
            isSyncing = false
            lastSyncErrorKind = nil
            Self.logger.info("TV listings sync finished")
            await fetch()
        } catch {
            Self.logger.error(
                "TV listings sync failed: \(error.localizedDescription, privacy: .public)"
            )
            isSyncing = false
            lastSyncErrorKind = ErrorKind(error)
        }
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

            // A newer fetch (e.g. one started by `sync()`) superseded this one —
            // drop the stale result so it can't clobber fresher listings.
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

        // Client channel order is preserved; programmes with no matching channel are dropped.
        return channels.flatMap { channel in
            (programmesByChannelID[channel.id] ?? []).map { programme in
                TVListingsNowPlayingItem(channel: channel, programme: programme)
            }
        }
    }

}

extension TVListingsViewModel.ErrorKind {

    init(_ error: any Error) {
        if let syncError = error as? SyncTVListingsError {
            self.init(syncError)
        } else {
            self = .unknown
        }
    }

    init(_ error: SyncTVListingsError) {
        switch error {
        case .remote:
            self = .network

        case .local:
            self = .local

        case .unknown:
            self = .unknown
        }
    }

}

#if DEBUG
    public extension TVListingsViewModel {

        /// A view model pinned to a fixed view state with no-op dependencies, for
        /// previews and snapshot tests.
        static func preview(
            viewState: ViewState<ViewSnapshot> = .initial,
            isSyncing: Bool = false,
            lastSyncErrorKind: ErrorKind? = nil
        ) -> TVListingsViewModel {
            TVListingsViewModel(
                dependencies: .preview,
                viewState: viewState,
                isSyncing: isSyncing,
                lastSyncErrorKind: lastSyncErrorKind
            )
        }

    }
#endif
