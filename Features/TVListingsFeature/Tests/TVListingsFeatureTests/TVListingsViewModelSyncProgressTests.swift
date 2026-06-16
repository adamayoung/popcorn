//
//  TVListingsViewModelSyncProgressTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Presentation
import Testing
import TVListingsDomain
@testable import TVListingsFeature

@Suite("TVListingsViewModel sync progress")
@MainActor
struct TVListingsViewModelSyncProgressTests {

    @Test("shouldShowSyncProgress is false when no sync is reporting progress")
    func hiddenWhenNoProgress() {
        let viewModel = Self.makeViewModel()

        #expect(viewModel.shouldShowSyncProgress == false)
    }

    @Test("shouldShowSyncProgress is true when syncing and no listings are cached for today")
    func shownWhenSyncingWithEmptyCache() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchListings: { [] })
        )

        await viewModel.load()
        viewModel.updateSyncProgress(0.3)

        #expect(viewModel.shouldShowSyncProgress == true)
    }

    @Test("shouldShowSyncProgress is false when syncing but today's listings are already cached")
    func hiddenWhenSyncingWithTodaysListings() async {
        let channel = Self.makeChannel(id: "BBC", name: "BBC")
        let programme = Self.makeProgramme(id: "BBC:1", channelID: "BBC", title: "News")
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchChannels: { [channel] },
                fetchListings: { [programme] }
            )
        )

        await viewModel.load()
        viewModel.updateSyncProgress(0.3)

        #expect(viewModel.shouldShowSyncProgress == false)
    }

    @Test("updateSyncProgress stores the value, and nil clears it")
    func updateSyncProgressStoresValue() {
        let viewModel = Self.makeViewModel()

        viewModel.updateSyncProgress(0.75)
        #expect(viewModel.syncProgress == 0.75)

        viewModel.updateSyncProgress(nil)
        #expect(viewModel.syncProgress == nil)
    }

    @Test("reload from an empty ready snapshot drops to loading to avoid an empty-state flash")
    func reloadFromEmptyShowsLoading() {
        let viewModel = Self.makeViewModel(viewState: .ready(TVListingsViewSnapshot()))

        viewModel.reload()

        #expect(viewModel.viewState.isLoading)
    }

    @Test("reload from a populated ready snapshot stays ready")
    func reloadFromPopulatedStaysReady() {
        let item = TVListingsNowPlayingItem(
            channel: Self.makeChannel(id: "BBC", name: "BBC"),
            programme: Self.makeProgramme(id: "BBC:1", channelID: "BBC", title: "News")
        )
        let viewModel = Self.makeViewModel(viewState: .ready(TVListingsViewSnapshot(items: [item])))

        viewModel.reload()

        #expect(viewModel.viewState.isReady)
    }

}

// MARK: - Helpers

extension TVListingsViewModelSyncProgressTests {

    nonisolated static let referenceNow = Date(timeIntervalSince1970: 1500)

    static func makeViewModel(
        dependencies: TVListingsDependencies = stubDependencies(),
        viewState: ViewState<TVListingsViewSnapshot> = .initial
    ) -> TVListingsViewModel {
        TVListingsViewModel(dependencies: dependencies, now: { referenceNow }, viewState: viewState)
    }

    static func stubDependencies(
        fetchChannels: @escaping @Sendable () async throws -> [Channel] = { [] },
        fetchRegions: @escaping @Sendable () async throws -> [TVRegion] = { [] },
        fetchListings: @escaping @Sendable () async throws -> [TVProgramme] = { [] },
        loadSelectedRegionID: @escaping @Sendable () -> String? = { nil },
        saveSelectedRegionID: @escaping @Sendable (String) -> Void = { _ in }
    ) -> TVListingsDependencies {
        TVListingsDependencies(
            fetchChannels: fetchChannels,
            fetchRegions: fetchRegions,
            fetchListings: fetchListings,
            loadSelectedRegionID: loadSelectedRegionID,
            saveSelectedRegionID: saveSelectedRegionID
        )
    }

    static func makeChannel(id: String, name: String) -> Channel {
        Channel(id: id, name: name, type: .television, isHD: false, logoURL: nil, channelNumbers: [])
    }

    static func makeProgramme(
        id: String,
        channelID: String,
        title: String,
        start: TimeInterval = 1000,
        end: TimeInterval = 1900
    ) -> TVProgramme {
        TVProgramme(
            id: id,
            channelID: channelID,
            title: title,
            description: "",
            startTime: Date(timeIntervalSince1970: start),
            endTime: Date(timeIntervalSince1970: end),
            duration: end - start,
            episodeNumber: nil,
            seasonNumber: nil,
            imageURL: nil,
            tmdbTVSeriesID: nil,
            tmdbMovieID: nil
        )
    }

}
