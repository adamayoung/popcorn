//
//  TVListingsFeatureTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TCAFoundation
import Testing
@testable import TVListingsApplication
import TVListingsDomain
@testable import TVListingsFeature

@MainActor
@Suite("TVListingsFeature")
struct TVListingsFeatureTests {

    // MARK: - fetch

    @Test("didAppear triggers fetch and produces a ready snapshot joining programmes to channels")
    func didAppearTriggersFetchAndProducesReadySnapshot() async {
        let bbc = TVChannel(
            id: "BBC",
            name: "BBC",
            isHD: false,
            logoURL: nil,
            channelNumbers: []
        )
        let itv = TVChannel(
            id: "ITV",
            name: "ITV",
            isHD: false,
            logoURL: nil,
            channelNumbers: []
        )
        let programme = TVProgramme(
            id: "BBC:1000",
            channelID: "BBC",
            title: "News",
            description: "",
            startTime: Date(timeIntervalSince1970: 1000),
            endTime: Date(timeIntervalSince1970: 1900),
            duration: 900,
            episodeNumber: nil,
            seasonNumber: nil,
            imageURL: nil,
            tmdbTVSeriesID: nil,
            tmdbMovieID: nil
        )
        let store = TestStore(initialState: TVListingsFeature.State()) {
            TVListingsFeature()
        } withDependencies: {
            $0.tvListingsClient.fetchChannels = { [bbc, itv] }
            $0.tvListingsClient.fetchNowPlayingProgrammes = { [programme] }
        }

        await store.send(.didAppear)
        await store.receive(\.fetch) {
            $0.viewState = .loading
        }
        await store.receive(\.nowPlayingLoaded) {
            $0.viewState = .ready(
                TVListingsFeature.ViewSnapshot(
                    items: [
                        TVListingsFeature.NowPlayingItem(channel: bbc, programme: programme)
                    ]
                )
            )
        }
    }

    @Test("fetch surfaces load failures as an error view state when no snapshot is present yet")
    func fetchSurfacesLoadFailureAsErrorState() async {
        struct LoadFailure: Error {}

        let store = TestStore(initialState: TVListingsFeature.State()) {
            TVListingsFeature()
        } withDependencies: {
            $0.tvListingsClient.fetchChannels = { throw LoadFailure() }
            $0.tvListingsClient.fetchNowPlayingProgrammes = { [] }
        }

        await store.send(.fetch) {
            $0.viewState = .loading
        }
        await store.receive(\.nowPlayingLoadFailed) {
            $0.viewState = .error(ViewStateError(LoadFailure()))
        }
    }

    @Test("didAppear is a no-op once a snapshot has already been loaded")
    func didAppearIsNoOpWhenSnapshotAlreadyLoaded() async {
        let state = TVListingsFeature.State(
            viewState: .ready(TVListingsFeature.ViewSnapshot())
        )
        let store = TestStore(initialState: state) { TVListingsFeature() }

        await store.send(.didAppear)
    }

    @Test("didAppear retries the fetch when the previous load errored")
    func didAppearRetriesFetchAfterError() async {
        let state = TVListingsFeature.State(
            viewState: .error(ViewStateError(message: "boom"))
        )
        let store = TestStore(initialState: state) {
            TVListingsFeature()
        } withDependencies: {
            $0.tvListingsClient.fetchChannels = { [] }
            $0.tvListingsClient.fetchNowPlayingProgrammes = { [] }
        }

        await store.send(.didAppear)
        await store.receive(\.fetch) {
            $0.viewState = .loading
        }
        await store.receive(\.nowPlayingLoaded) {
            $0.viewState = .ready(TVListingsFeature.ViewSnapshot(items: []))
        }
    }

    // MARK: - sync

    @Test("syncTapped starts syncing, and syncFinished refreshes the listings")
    func syncTappedResolvesOnSuccessAndReloads() async {
        let store = TestStore(initialState: TVListingsFeature.State()) {
            TVListingsFeature()
        } withDependencies: {
            $0.tvListingsClient.sync = {}
            $0.tvListingsClient.fetchChannels = { [] }
            $0.tvListingsClient.fetchNowPlayingProgrammes = { [] }
        }

        await store.send(.syncTapped) {
            $0.isSyncing = true
            $0.lastSyncErrorKind = nil
        }

        await store.receive(\.syncFinished) {
            $0.isSyncing = false
            $0.lastSyncErrorKind = nil
        }

        await store.receive(\.fetch) {
            $0.viewState = .loading
        }

        await store.receive(\.nowPlayingLoaded) {
            $0.viewState = .ready(TVListingsFeature.ViewSnapshot(items: []))
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

    @Test("dismissSyncError clears the error kind")
    func dismissSyncErrorClearsTheErrorKind() async {
        let store = TestStore(
            initialState: TVListingsFeature.State(lastSyncErrorKind: .network)
        ) {
            TVListingsFeature()
        }

        await store.send(.dismissSyncError) {
            $0.lastSyncErrorKind = nil
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
            $0.tvListingsClient.fetchChannels = { [] }
            $0.tvListingsClient.fetchNowPlayingProgrammes = { [] }
        }

        await store.send(.syncTapped) {
            $0.isSyncing = true
            $0.lastSyncErrorKind = nil
        }

        await store.receive(\.syncFinished) {
            $0.isSyncing = false
        }

        await store.receive(\.fetch) {
            $0.viewState = .loading
        }

        await store.receive(\.nowPlayingLoaded) {
            $0.viewState = .ready(TVListingsFeature.ViewSnapshot(items: []))
        }
    }

}
