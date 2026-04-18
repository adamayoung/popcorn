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

@Reducer
public struct TVListingsFeature: Sendable {

    private static let logger = Logger.tvListings

    @Dependency(\.tvListingsClient) private var client

    @ObservableState
    public struct State: Sendable, Equatable {

        public var isSyncing: Bool
        public var lastSyncError: String?

        public init(
            isSyncing: Bool = false,
            lastSyncError: String? = nil
        ) {
            self.isSyncing = isSyncing
            self.lastSyncError = lastSyncError
        }

    }

    public enum Action {
        case syncTapped
        case syncFinished
        case syncFailed(String)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .syncTapped:
                guard !state.isSyncing else {
                    return .none
                }
                state.isSyncing = true
                state.lastSyncError = nil
                return .run { [client] send in
                    Self.logger.info("Starting TV listings sync")
                    do {
                        try await client.sync()
                        await send(.syncFinished)
                    } catch {
                        Self.logger.error(
                            "TV listings sync failed: \(error.localizedDescription, privacy: .public)"
                        )
                        await send(.syncFailed(error.localizedDescription))
                    }
                }

            case .syncFinished:
                Self.logger.info("TV listings sync finished")
                state.isSyncing = false
                state.lastSyncError = nil
                return .none

            case .syncFailed(let message):
                state.isSyncing = false
                state.lastSyncError = message
                return .none
            }
        }
    }

}
