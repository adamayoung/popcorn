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

    @Test("a superseded slow fetch does not overwrite a newer fetch's listings")
    @MainActor
    func staleFetchDoesNotClobberFreshListings() async {
        let gate = AsyncGate()
        let callCount = Mutex(0)
        let staleChannel = Self.makeChannel(id: "STALE", name: "Stale")
        let freshChannel = Self.makeChannel(id: "FRESH", name: "Fresh")
        let staleProgramme = Self.makeProgramme(id: "STALE:1", channelID: "STALE", title: "Old")
        let freshProgramme = Self.makeProgramme(id: "FRESH:1", channelID: "FRESH", title: "New")
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchChannels: {
                    let callNumber = callCount.withLock { $0 += 1; return $0 }
                    if callNumber == 1 {
                        await gate.wait()
                        return [staleChannel]
                    }
                    return [freshChannel]
                },
                fetchNowPlayingProgrammes: { [staleProgramme, freshProgramme] }
            )
        )
        let expected = TVListingsViewSnapshot(items: [
            TVListingsNowPlayingItem(channel: freshChannel, programme: freshProgramme)
        ])

        // Start the slow first fetch; it blocks inside fetchChannels.
        async let firstFetch: Void = viewModel.load()
        await gate.waitUntilWaiting()

        // A second fetch (as `refresh()` would trigger) completes with fresh data.
        await viewModel.refresh()
        #expect(viewModel.viewState == .ready(expected))

        // Release the stale fetch; its result must be dropped, not clobber fresh.
        gate.open()
        await firstFetch
        #expect(viewModel.viewState == .ready(expected))
    }

    @Test("cancelled load does not surface a spurious error")
    @MainActor
    func cancelledLoadDoesNotError() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchChannels: { throw CancellationError() }
            )
        )

        await viewModel.load()

        #expect(viewModel.viewState.isError == false)
    }

    // MARK: - refresh / reload

    @Test("refresh re-reads the cache and updates the snapshot")
    @MainActor
    func refreshReReadsCache() async {
        let channels = Mutex([Self.makeChannel(id: "BBC", name: "BBC")])
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchChannels: { channels.withLock { $0 } },
                fetchNowPlayingProgrammes: { [Self.makeProgramme(id: "BBC:1000", channelID: "BBC", title: "News")] }
            )
        )

        await viewModel.load()
        // Simulate a background sync clearing the cache; a refresh must reflect it.
        channels.withLock { $0 = [] }
        await viewModel.refresh()

        #expect(viewModel.viewState == .ready(TVListingsViewSnapshot(items: [])))
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
        viewState: ViewState<TVListingsViewSnapshot> = .initial
    ) -> TVListingsViewModel {
        TVListingsViewModel(dependencies: dependencies, viewState: viewState)
    }

    static func stubDependencies(
        fetchChannels: @escaping @Sendable () async throws -> [TVChannel] = { [] },
        fetchNowPlayingProgrammes: @escaping @Sendable () async throws -> [TVProgramme] = { [] }
    ) -> TVListingsDependencies {
        TVListingsDependencies(
            fetchChannels: fetchChannels,
            fetchNowPlayingProgrammes: fetchNowPlayingProgrammes
        )
    }

}

// MARK: - Test Data

extension TVListingsViewModelTests {

    static func makeChannel(id: String, name: String) -> TVChannel {
        TVChannel(id: id, name: name, isHD: false, logoURL: nil, channelNumbers: [])
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
