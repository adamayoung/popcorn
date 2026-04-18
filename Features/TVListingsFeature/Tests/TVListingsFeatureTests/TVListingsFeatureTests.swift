//
//  TVListingsFeatureTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import Testing
@testable import TVListingsFeature

@MainActor
@Suite("TVListingsFeature")
struct TVListingsFeatureTests {

    @Test("syncTapped starts syncing and resolves on success")
    func syncTappedStartsSyncingAndResolvesOnSuccess() async {
        let store = TestStore(initialState: TVListingsFeature.State()) {
            TVListingsFeature()
        } withDependencies: {
            $0.tvListingsClient.sync = {}
        }

        await store.send(.syncTapped) {
            $0.isSyncing = true
            $0.lastSyncError = nil
        }

        await store.receive(\.syncFinished) {
            $0.isSyncing = false
            $0.lastSyncError = nil
        }
    }

    @Test("syncTapped sets lastSyncError when the client throws")
    func syncTappedSetsLastSyncErrorWhenClientThrows() async {
        struct SyncFailure: Error, LocalizedError {
            var errorDescription: String? {
                "Something went wrong"
            }
        }

        let store = TestStore(initialState: TVListingsFeature.State()) {
            TVListingsFeature()
        } withDependencies: {
            $0.tvListingsClient.sync = { throw SyncFailure() }
        }

        await store.send(.syncTapped) {
            $0.isSyncing = true
            $0.lastSyncError = nil
        }

        await store.receive(\.syncFailed) {
            $0.isSyncing = false
            $0.lastSyncError = "Something went wrong"
        }
    }

    @Test("syncTapped is a no-op while already syncing")
    func syncTappedIsNoOpWhileAlreadySyncing() async {
        let store = TestStore(
            initialState: TVListingsFeature.State(isSyncing: true)
        ) {
            TVListingsFeature()
        }

        await store.send(.syncTapped)
    }

    @Test("syncTapped clears previous error before starting")
    func syncTappedClearsPreviousError() async {
        let store = TestStore(
            initialState: TVListingsFeature.State(lastSyncError: "stale")
        ) {
            TVListingsFeature()
        } withDependencies: {
            $0.tvListingsClient.sync = {}
        }

        await store.send(.syncTapped) {
            $0.isSyncing = true
            $0.lastSyncError = nil
        }

        await store.receive(\.syncFinished) {
            $0.isSyncing = false
        }
    }

}
