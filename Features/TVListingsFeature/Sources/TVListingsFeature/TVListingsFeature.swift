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
import TVListingsApplication

@Reducer
public struct TVListingsFeature: Sendable {

    private static let logger = Logger.tvListings

    @Dependency(\.tvListingsClient) private var client

    @ObservableState
    public struct State: Sendable, Equatable {

        public var isSyncing: Bool
        public var lastSyncErrorKind: ErrorKind?

        public init(
            isSyncing: Bool = false,
            lastSyncErrorKind: ErrorKind? = nil
        ) {
            self.isSyncing = isSyncing
            self.lastSyncErrorKind = lastSyncErrorKind
        }

    }

    public enum ErrorKind: Equatable, Sendable {
        case network
        case local
        case unknown
    }

    public enum Action {
        case syncTapped
        case syncFinished
        case syncFailed(ErrorKind)
    }

    public init() {}

    private enum CancelID { case sync }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
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
                return .none

            case .syncFailed(let kind):
                state.isSyncing = false
                state.lastSyncErrorKind = kind
                return .none
            }
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
