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

    @Test("load success builds a ready snapshot with a row per channel")
    @MainActor
    func loadSuccessBuildsRowPerChannel() async {
        let bbc = Self.makeChannel(id: "BBC", name: "BBC")
        let itv = Self.makeChannel(id: "ITV", name: "ITV")
        let programme = Self.makeProgramme(id: "BBC:1000", channelID: "BBC", title: "News")
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchChannels: { [bbc, itv] },
                fetchListings: { [programme] }
            )
        )

        await viewModel.load()

        let rows = Self.readyRows(viewModel)
        #expect(rows.map(\.id) == ["BBC", "ITV"])
        #expect(rows.first?.programmes.map(\.id) == ["BBC:1000"])
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
                fetchListings: { [itvProgramme, bbcOneProgramme] }
            )
        )

        await viewModel.load()

        #expect(Self.readyRows(viewModel).map(\.id) == ["BBC_ONE", "ITV"])
    }

    @Test("empty channels list yields a ready snapshot with no rows")
    @MainActor
    func emptyChannelsYieldsNoRows() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchChannels: { [] },
                fetchListings: { [Self.makeProgramme(id: "X:1", channelID: "X", title: "Orphan")] }
            )
        )

        await viewModel.load()

        #expect(Self.readyRows(viewModel).isEmpty)
    }

    @Test("a channel with no programmes still yields a row with empty programmes")
    @MainActor
    func channelWithoutProgrammesStillYieldsRow() async {
        let bbc = Self.makeChannel(id: "BBC", name: "BBC")
        let itv = Self.makeChannel(id: "ITV", name: "ITV")
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchChannels: { [bbc, itv] },
                fetchListings: { [Self.makeProgramme(id: "BBC:1", channelID: "BBC", title: "News")] }
            )
        )

        await viewModel.load()

        let rows = Self.readyRows(viewModel)
        #expect(rows.map(\.id) == ["BBC", "ITV"])
        #expect(rows.last?.programmes.isEmpty == true)
    }

    @Test("a programme with no matching channel is dropped as an orphan")
    @MainActor
    func orphanProgrammeIsDropped() async {
        let bbc = Self.makeChannel(id: "BBC", name: "BBC")
        let bbcProgramme = Self.makeProgramme(id: "BBC:1", channelID: "BBC", title: "News")
        let orphan = Self.makeProgramme(id: "GONE:1", channelID: "GONE", title: "Ghost")
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchChannels: { [bbc] },
                fetchListings: { [bbcProgramme, orphan] }
            )
        )

        await viewModel.load()

        let rows = Self.readyRows(viewModel)
        #expect(rows.count == 1)
        #expect(rows.first?.programmes.map(\.id) == ["BBC:1"])
    }

    @Test("programmes within a channel are ordered by start time")
    @MainActor
    func programmesOrderedByStartTime() async {
        let bbc = Self.makeChannel(id: "BBC", name: "BBC")
        let later = Self.makeProgramme(id: "BBC:2", channelID: "BBC", title: "Late", start: 2000, end: 3000)
        let earlier = Self.makeProgramme(id: "BBC:1", channelID: "BBC", title: "Early", start: 1000, end: 2000)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchChannels: { [bbc] },
                fetchListings: { [later, earlier] }
            )
        )

        await viewModel.load()

        #expect(Self.readyRows(viewModel).first?.programmes.map(\.id) == ["BBC:1", "BBC:2"])
    }

    @Test("an airing-now programme reports isAiringNow with progress in 0...1")
    @MainActor
    func airingNowProgrammeComputesProgress() async {
        let bbc = Self.makeChannel(id: "BBC", name: "BBC")
        // start 1000, end 2000, duration 1000; now 1250 → 25% elapsed.
        let programme = Self.makeProgramme(
            id: "BBC:1", channelID: "BBC", title: "Live", start: 1000, end: 2000, duration: 1000
        )
        let now = Date(timeIntervalSince1970: 1250)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchChannels: { [bbc] },
                fetchListings: { [programme] }
            ),
            now: { now }
        )

        await viewModel.load()

        let item = Self.readyRows(viewModel).first?.programmes.first
        #expect(item?.isAiringNow == true)
        #expect(item?.progress == 0.25)
    }

    @Test("a future programme is not airing and reports zero progress")
    @MainActor
    func futureProgrammeIsNotAiring() async {
        let bbc = Self.makeChannel(id: "BBC", name: "BBC")
        let programme = Self.makeProgramme(
            id: "BBC:1", channelID: "BBC", title: "Later", start: 5000, end: 6000, duration: 1000
        )
        let now = Date(timeIntervalSince1970: 1000)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchChannels: { [bbc] },
                fetchListings: { [programme] }
            ),
            now: { now }
        )

        await viewModel.load()

        let item = Self.readyRows(viewModel).first?.programmes.first
        #expect(item?.isAiringNow == false)
        #expect(item?.progress == 0)
    }

    @Test("the first genre is surfaced on the programme item")
    @MainActor
    func firstGenreIsSurfaced() async {
        let bbc = Self.makeChannel(id: "BBC", name: "BBC")
        let programme = Self.makeProgramme(
            id: "BBC:1", channelID: "BBC", title: "Film", genres: ["Drama", "Thriller"]
        )
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchChannels: { [bbc] },
                fetchListings: { [programme] }
            )
        )

        await viewModel.load()

        #expect(Self.readyRows(viewModel).first?.programmes.first?.genre == "Drama")
    }

    @Test("duplicate channel and programme ids are handled without crashing")
    @MainActor
    func duplicateIDsHandledWithoutCrash() async {
        let bbc = Self.makeChannel(id: "BBC", name: "BBC")
        let bbcDuplicate = Self.makeChannel(id: "BBC", name: "BBC (dup)")
        let programme = Self.makeProgramme(id: "BBC:1", channelID: "BBC", title: "News")
        let duplicateProgramme = Self.makeProgramme(id: "BBC:1", channelID: "BBC", title: "News (dup)")
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchChannels: { [bbc, bbcDuplicate] },
                fetchListings: { [programme, duplicateProgramme] }
            )
        )

        await viewModel.load()

        // Two channel rows (the duplicate is preserved as its own row), each
        // receiving both programmes grouped by channelID.
        #expect(Self.readyRows(viewModel).count == 2)
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
                fetchListings: { [staleProgramme, freshProgramme] }
            )
        )

        // Start the slow first fetch; it blocks inside fetchChannels.
        async let firstFetch: Void = viewModel.load()
        await gate.waitUntilWaiting()

        // A second fetch (as `refresh()` would trigger) completes with fresh data.
        await viewModel.refresh()
        #expect(Self.readyRows(viewModel).map(\.id) == ["FRESH"])

        // Release the stale fetch; its result must be dropped, not clobber fresh.
        gate.open()
        await firstFetch
        #expect(Self.readyRows(viewModel).map(\.id) == ["FRESH"])
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
                fetchListings: { [Self.makeProgramme(id: "BBC:1000", channelID: "BBC", title: "News")] }
            )
        )

        await viewModel.load()
        // Simulate a background sync clearing the cache; a refresh must reflect it.
        channels.withLock { $0 = [] }
        await viewModel.refresh()

        #expect(Self.readyRows(viewModel).isEmpty)
    }

    @Test("reload bumps reloadID")
    @MainActor
    func reloadBumpsReloadID() {
        let viewModel = Self.makeViewModel(dependencies: Self.stubDependencies())

        viewModel.reload()

        #expect(viewModel.reloadID == 1)
    }

}
