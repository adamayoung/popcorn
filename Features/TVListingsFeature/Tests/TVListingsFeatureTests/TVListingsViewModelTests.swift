//
//  TVListingsViewModelTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Presentation
import Synchronization
import Testing
@testable import TVListingsApplication
import TVListingsDomain
@testable import TVListingsFeature

@Suite("TVListingsViewModel Tests")
struct TVListingsViewModelTests {

    // MARK: - load

    @Test("load success builds a ready snapshot joining programmes to channels")
    @MainActor
    func loadSuccessBuildsReadySnapshot() async {
        let bbc = Self.makeChannel(id: "BBC", name: "BBC")
        let itv = Self.makeChannel(id: "ITV", name: "ITV")
        let programme = Self.makeProgramme(id: "BBC:1000", channelID: "BBC", title: "News")
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchChannels: { [bbc, itv] },
                fetchNowPlayingProgrammes: { [programme] }
            )
        )

        await viewModel.load()

        #expect(viewModel.viewState == .ready(
            TVListingsViewSnapshot(items: [
                TVListingsNowPlayingItem(channel: bbc, programme: programme)
            ])
        ))
    }

    @Test("load preserves the channel order provided by the dependency")
    @MainActor
    func loadPreservesChannelOrder() async {
        let bbcOne = Self.makeChannel(id: "BBC_ONE", name: "BBC One")
        let itv = Self.makeChannel(id: "ITV", name: "ITV")
        let bbcOneProgramme = Self.makeProgramme(id: "BBC_ONE:1", channelID: "BBC_ONE", title: "News")
        let itvProgramme = Self.makeProgramme(id: "ITV:1", channelID: "ITV", title: "Weather")
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchChannels: { [bbcOne, itv] },
                fetchNowPlayingProgrammes: { [itvProgramme, bbcOneProgramme] }
            )
        )

        await viewModel.load()

        #expect(viewModel.viewState == .ready(
            TVListingsViewSnapshot(items: [
                TVListingsNowPlayingItem(channel: bbcOne, programme: bbcOneProgramme),
                TVListingsNowPlayingItem(channel: itv, programme: itvProgramme)
            ])
        ))
    }

    @Test("load failure sets viewState to error")
    @MainActor
    func loadFailureSetsError() async {
        struct LoadFailure: Error {}

        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchChannels: { throw LoadFailure() }
            )
        )

        await viewModel.load()

        #expect(viewModel.viewState == .error(ViewStateError(LoadFailure())))
    }

    // MARK: - sync

    @Test("sync sets isSyncing true mid-flight then false and refetches on success")
    @MainActor
    func syncTogglesIsSyncingAndRefetches() async {
        let gate = AsyncGate()
        let fetchCount = Mutex(0)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                sync: { await gate.wait() },
                fetchChannels: {
                    fetchCount.withLock { $0 += 1 }
                    return []
                },
                fetchNowPlayingProgrammes: { [] }
            )
        )

        let task = Task { await viewModel.sync() }
        await gate.waitUntilWaiting()

        #expect(viewModel.isSyncing == true)
        #expect(viewModel.lastSyncErrorKind == nil)

        gate.open()
        await task.value

        #expect(viewModel.isSyncing == false)
        #expect(viewModel.lastSyncErrorKind == nil)
        // A successful sync triggers a refetch.
        #expect(fetchCount.withLock { $0 } == 1)
        #expect(viewModel.viewState == .ready(TVListingsViewSnapshot(items: [])))
    }

    @Test("sync failure maps remote error to network kind and resets isSyncing")
    @MainActor
    func syncFailureMapsRemoteToNetwork() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                sync: { throw SyncTVListingsError.remote(nil) }
            )
        )

        await viewModel.sync()

        #expect(viewModel.isSyncing == false)
        #expect(viewModel.lastSyncErrorKind == .network)
    }

    @Test("sync failure maps local error to local kind")
    @MainActor
    func syncFailureMapsLocalToLocal() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                sync: { throw SyncTVListingsError.local(nil) }
            )
        )

        await viewModel.sync()

        #expect(viewModel.isSyncing == false)
        #expect(viewModel.lastSyncErrorKind == .local)
    }

    @Test("sync failure maps unexpected errors to unknown kind")
    @MainActor
    func syncFailureMapsUnexpectedToUnknown() async {
        struct UnexpectedFailure: Error {}

        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                sync: { throw UnexpectedFailure() }
            )
        )

        await viewModel.sync()

        #expect(viewModel.isSyncing == false)
        #expect(viewModel.lastSyncErrorKind == .unknown)
    }

    @Test("sync is a no-op while already syncing")
    @MainActor
    func syncNoOpWhileSyncing() async {
        let syncCalled = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                sync: { syncCalled.withLock { $0 = true } }
            ),
            isSyncing: true
        )

        await viewModel.sync()

        #expect(syncCalled.withLock { $0 } == false)
        #expect(viewModel.isSyncing == true)
    }

    @Test("sync clears a previous error before starting")
    @MainActor
    func syncClearsPreviousError() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(sync: {}),
            lastSyncErrorKind: .network
        )

        await viewModel.sync()

        #expect(viewModel.lastSyncErrorKind == nil)
    }

    @Test("dismissSyncError clears the error kind")
    @MainActor
    func dismissSyncErrorClearsErrorKind() {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(),
            lastSyncErrorKind: .network
        )

        viewModel.dismissSyncError()

        #expect(viewModel.lastSyncErrorKind == nil)
    }

    @Test("reload bumps reloadID")
    @MainActor
    func reloadBumpsReloadID() {
        let viewModel = Self.makeViewModel(dependencies: Self.stubDependencies())

        viewModel.reload()

        #expect(viewModel.reloadID == 1)
    }

}

// MARK: - Async Gate

/// A one-shot gate used to hold a stubbed async closure mid-flight so a test can
/// observe in-flight state, then release it.
private final class AsyncGate: Sendable {

    private let state = Mutex(State())

    private struct State {
        var isOpen = false
        var isWaiting = false
        var resume: (@Sendable () -> Void)?
    }

    /// Suspends until ``open()`` is called. Records that a caller is waiting so a
    /// test can synchronise on it via ``waitUntilWaiting()``.
    func wait() async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            let shouldResumeImmediately = state.withLock { state -> Bool in
                if state.isOpen {
                    return true
                }
                state.isWaiting = true
                state.resume = { continuation.resume() }
                return false
            }
            if shouldResumeImmediately {
                continuation.resume()
            }
        }
    }

    /// Releases the suspended ``wait()``.
    func open() {
        let resume = state.withLock { state -> (@Sendable () -> Void)? in
            state.isOpen = true
            let resume = state.resume
            state.resume = nil
            return resume
        }
        resume?()
    }

    /// Polls until a caller is suspended inside ``wait()``.
    func waitUntilWaiting() async {
        while !state.withLock(\.isWaiting) {
            await Task.yield()
        }
    }

}

// MARK: - Factories

extension TVListingsViewModelTests {

    @MainActor
    static func makeViewModel(
        dependencies: TVListingsDependencies = stubDependencies(),
        viewState: ViewState<TVListingsViewSnapshot> = .initial,
        isSyncing: Bool = false,
        lastSyncErrorKind: TVListingsViewModel.ErrorKind? = nil
    ) -> TVListingsViewModel {
        TVListingsViewModel(
            dependencies: dependencies,
            viewState: viewState,
            isSyncing: isSyncing,
            lastSyncErrorKind: lastSyncErrorKind
        )
    }

    static func stubDependencies(
        sync: @escaping @Sendable () async throws -> Void = {},
        fetchChannels: @escaping @Sendable () async throws -> [TVChannel] = { [] },
        fetchNowPlayingProgrammes: @escaping @Sendable () async throws -> [TVProgramme] = { [] }
    ) -> TVListingsDependencies {
        TVListingsDependencies(
            sync: sync,
            fetchChannels: fetchChannels,
            fetchNowPlayingProgrammes: fetchNowPlayingProgrammes
        )
    }

}

// MARK: - Test Data

extension TVListingsViewModelTests {

    static func makeChannel(id: String, name: String) -> TVChannel {
        TVChannel(
            id: id,
            name: name,
            isHD: false,
            logoURL: nil,
            channelNumbers: []
        )
    }

    static func makeProgramme(id: String, channelID: String, title: String) -> TVProgramme {
        TVProgramme(
            id: id,
            channelID: channelID,
            title: title,
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
    }

}
