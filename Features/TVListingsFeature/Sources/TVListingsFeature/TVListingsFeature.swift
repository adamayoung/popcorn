//
//  TVListingsFeature.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import OSLog
import TCAFoundation
import TVListingsApplication
import TVListingsDomain

@Reducer
public struct TVListingsFeature: Sendable {

    private static let logger = Logger.tvListings

    @Dependency(\.tvListingsClient) private var client

    @ObservableState
    public struct State: Sendable, Equatable {

        public var viewState: ViewState<ViewSnapshot>
        public var isSyncing: Bool
        public var lastSyncErrorKind: ErrorKind?

        public init(
            viewState: ViewState<ViewSnapshot> = .initial,
            isSyncing: Bool = false,
            lastSyncErrorKind: ErrorKind? = nil
        ) {
            self.viewState = viewState
            self.isSyncing = isSyncing
            self.lastSyncErrorKind = lastSyncErrorKind
        }

    }

    public struct ViewSnapshot: Equatable, Sendable {

        public let items: [NowPlayingItem]

        public init(items: [NowPlayingItem] = []) {
            self.items = items
        }

    }

    public struct NowPlayingItem: Identifiable, Equatable, Sendable {

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

    public enum ErrorKind: Equatable, Sendable {
        case network
        case local
        case unknown
    }

    public enum Action {
        case didAppear
        case fetch
        case nowPlayingLoaded(ViewSnapshot)
        case nowPlayingLoadFailed(ViewStateError)
        case syncTapped
        case syncFinished
        case syncFailed(ErrorKind)
        case dismissSyncError
    }

    public init() {}

    private enum CancelID: Hashable { case sync, fetch }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didAppear:
                guard state.viewState.isInitial else {
                    return .none
                }
                return .send(.fetch)

            case .fetch:
                if !state.viewState.isReady {
                    state.viewState = .loading
                }
                return .run { [client] send in
                    await handleFetch(client: client, send: send)
                }
                .cancellable(id: CancelID.fetch, cancelInFlight: true)

            case .nowPlayingLoaded(let snapshot):
                state.viewState = .ready(snapshot)
                return .none

            case .nowPlayingLoadFailed(let error):
                if !state.viewState.isReady {
                    state.viewState = .error(error)
                }
                return .none

            case .syncTapped:
                guard !state.isSyncing else {
                    return .none
                }
                state.isSyncing = true
                state.lastSyncErrorKind = nil
                return .run { [client] send in
                    Self.logger.info("Starting TV listings sync")
                    do {
                        try await client.sync()
                        await send(.syncFinished)
                    } catch {
                        Self.logger.error(
                            "TV listings sync failed: \(error.localizedDescription, privacy: .public)"
                        )
                        await send(.syncFailed(ErrorKind(error)))
                    }
                }
                .cancellable(id: CancelID.sync, cancelInFlight: true)

            case .syncFinished:
                Self.logger.info("TV listings sync finished")
                state.isSyncing = false
                state.lastSyncErrorKind = nil
                return .send(.fetch)

            case .syncFailed(let kind):
                state.isSyncing = false
                state.lastSyncErrorKind = kind
                return .none

            case .dismissSyncError:
                state.lastSyncErrorKind = nil
                return .none
            }
        }
    }

}

extension TVListingsFeature {

    private func handleFetch(
        client: TVListingsClient,
        send: Send<Action>
    ) async {
        do {
            async let channelsTask = client.fetchChannels()
            async let programmesTask = client.fetchNowPlayingProgrammes()
            let (channels, programmes) = try await (channelsTask, programmesTask)

            let snapshot = ViewSnapshot(items: buildItems(channels: channels, programmes: programmes))
            await send(.nowPlayingLoaded(snapshot))
        } catch {
            Self.logger.error(
                "Failed loading now-playing TV listings: \(error.localizedDescription, privacy: .public)"
            )
            await send(.nowPlayingLoadFailed(ViewStateError(error)))
        }
    }

    private func buildItems(
        channels: [TVChannel],
        programmes: [TVProgramme]
    ) -> [NowPlayingItem] {
        let channelsByID = Dictionary(uniqueKeysWithValues: channels.map { ($0.id, $0) })

        return programmes
            .compactMap { programme in
                guard let channel = channelsByID[programme.channelID] else {
                    return nil
                }
                return NowPlayingItem(channel: channel, programme: programme)
            }
            .sorted { lhs, rhs in
                lhs.channel.name.localizedCaseInsensitiveCompare(rhs.channel.name) == .orderedAscending
            }
    }

}

extension TVListingsFeature.ErrorKind {

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
