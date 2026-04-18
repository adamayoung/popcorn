//
//  TVListingsFeatureTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import Testing
@testable import TVListingsApplication
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
            $0.lastSyncErrorKind = nil
        }

        await store.receive(\.syncFinished) {
            $0.isSyncing = false
            $0.lastSyncErrorKind = nil
        }
    }

    @Test("syncTapped maps SyncTVListingsError.remote to the network error kind")
    func syncTappedMapsRemoteErrorToNetworkKind() async {
        let store = TestStore(initialState: TVListingsFeature.State()) {
            TVListingsFeature()
        } withDependencies: {
            $0.tvListingsClient.sync = { throw SyncTVListingsError.remote(nil) }
        }

        await store.send(.syncTapped) {
            $0.isSyncing = true
            $0.lastSyncErrorKind = nil
        }

        await store.receive(\.syncFailed) {
            $0.isSyncing = false
            $0.lastSyncErrorKind = .network
        }
    }

    @Test("syncTapped maps SyncTVListingsError.local to the local error kind")
    func syncTappedMapsLocalErrorToLocalKind() async {
        let store = TestStore(initialState: TVListingsFeature.State()) {
            TVListingsFeature()
        } withDependencies: {
            $0.tvListingsClient.sync = { throw SyncTVListingsError.local(nil) }
        }

        await store.send(.syncTapped) {
            $0.isSyncing = true
            $0.lastSyncErrorKind = nil
        }

        await store.receive(\.syncFailed) {
            $0.isSyncing = false
            $0.lastSyncErrorKind = .local
        }
    }

    @Test("syncTapped maps unknown errors to the unknown error kind")
    func syncTappedMapsUnknownErrorsToUnknownKind() async {
        struct UnexpectedFailure: Error {}

        let store = TestStore(initialState: TVListingsFeature.State()) {
            TVListingsFeature()
        } withDependencies: {
            $0.tvListingsClient.sync = { throw UnexpectedFailure() }
        }

        await store.send(.syncTapped) {
            $0.isSyncing = true
            $0.lastSyncErrorKind = nil
        }

        await store.receive(\.syncFailed) {
            $0.isSyncing = false
            $0.lastSyncErrorKind = .unknown
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
            initialState: TVListingsFeature.State(lastSyncErrorKind: .network)
        ) {
            TVListingsFeature()
        } withDependencies: {
            $0.tvListingsClient.sync = {}
        }

        await store.send(.syncTapped) {
            $0.isSyncing = true
            $0.lastSyncErrorKind = nil
        }

        await store.receive(\.syncFinished) {
            $0.isSyncing = false
        }
    }

}
