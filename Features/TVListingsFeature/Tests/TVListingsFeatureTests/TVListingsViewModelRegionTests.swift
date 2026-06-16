//
//  TVListingsViewModelRegionTests.swift
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

@Suite("TVListingsViewModel Region Filtering")
@MainActor
struct TVListingsViewModelRegionTests {

    /// London (England#1) HD + SD, Essex (England#2) HD + SD.
    static let regions = [
        TVRegion(bouquet: 4101, subBouquet: 1, name: "London", nation: "England", isHD: true),
        TVRegion(bouquet: 4097, subBouquet: 1, name: "London", nation: "England", isHD: false),
        TVRegion(bouquet: 4101, subBouquet: 2, name: "Essex", nation: "England", isHD: true),
        TVRegion(bouquet: 4097, subBouquet: 2, name: "Essex", nation: "England", isHD: false)
    ]

    @Test("defaults to London and shows only its channels")
    func defaultsToLondonAndFiltersChannels() async {
        let viewModel = makeViewModel(
            channels: [channel(id: "LON", subBouquet: 1), channel(id: "ESX", subBouquet: 2)],
            regions: Self.regions
        )

        await viewModel.load()

        #expect(viewModel.selectedRegion?.id == "England#1")
        #expect(itemChannelIDs(viewModel) == ["LON"])
        #expect(viewModel.regionsByNation.map(\.nation) == ["England"])
        #expect(viewModel.regionsByNation.first?.regions.map(\.name) == ["Essex", "London"])
    }

    @Test("restores the persisted region")
    func restoresPersistedRegion() async {
        let viewModel = makeViewModel(
            channels: [channel(id: "LON", subBouquet: 1), channel(id: "ESX", subBouquet: 2)],
            regions: Self.regions,
            persistedID: "England#2"
        )

        await viewModel.load()

        #expect(viewModel.selectedRegion?.id == "England#2")
        #expect(itemChannelIDs(viewModel) == ["ESX"])
    }

    @Test("a stale persisted region id falls back to London")
    func stalePersistedIDFallsBackToLondon() async {
        let viewModel = makeViewModel(
            channels: [channel(id: "LON", subBouquet: 1)],
            regions: Self.regions,
            persistedID: "Atlantis#9"
        )

        await viewModel.load()

        #expect(viewModel.selectedRegion?.id == "England#1")
    }

    @Test("selecting a region re-filters the list and persists the id")
    func selectRegionFiltersAndPersists() async throws {
        let saved = Mutex<String?>(nil)
        let viewModel = makeViewModel(
            channels: [channel(id: "LON", subBouquet: 1), channel(id: "ESX", subBouquet: 2)],
            regions: Self.regions,
            saveSelectedRegionID: { id in saved.withLock { $0 = id } }
        )
        await viewModel.load()

        let essex = try #require(viewModel.regionsByNation.first?.regions.first { $0.id == "England#2" })
        viewModel.selectRegion(essex)

        #expect(itemChannelIDs(viewModel) == ["ESX"])
        #expect(saved.withLock { $0 } == "England#2")
    }

    @Test("selecting a region does not refetch")
    func selectRegionDoesNotRefetch() async throws {
        let channelCalls = Mutex(0)
        let listingsCalls = Mutex(0)
        let viewModel = makeViewModel(
            channels: [channel(id: "LON", subBouquet: 1), channel(id: "ESX", subBouquet: 2)],
            regions: Self.regions,
            onFetchChannels: { channelCalls.withLock { $0 += 1 } },
            onFetchListings: { listingsCalls.withLock { $0 += 1 } }
        )
        await viewModel.load()

        let essex = try #require(viewModel.regionsByNation.first?.regions.first { $0.id == "England#2" })
        viewModel.selectRegion(essex)
        viewModel.selectRegion(essex)

        #expect(channelCalls.withLock { $0 } == 1)
        #expect(listingsCalls.withLock { $0 } == 1)
    }

    @Test("channels with no defined region never appear")
    func channelsWithNoRegionNeverAppear() async {
        let viewModel = makeViewModel(
            channels: [channel(id: "LON", subBouquet: 1), channel(id: "NOWHERE", subBouquet: nil)],
            regions: Self.regions
        )

        await viewModel.load()

        #expect(itemChannelIDs(viewModel) == ["LON"])
    }

    @Test("with no region data, all channels are shown (degraded fallback)")
    func degradedFallbackWhenNoRegions() async {
        let viewModel = makeViewModel(
            channels: [channel(id: "LON", subBouquet: 1), channel(id: "NOWHERE", subBouquet: nil)],
            regions: []
        )

        await viewModel.load()

        #expect(viewModel.selectedRegion == nil)
        #expect(viewModel.regionsByNation.isEmpty)
        #expect(Set(itemChannelIDs(viewModel)) == ["LON", "NOWHERE"])
    }

    @Test("regionsByNation orders nations by preference then unknown nations alphabetically")
    func regionsByNationOrdering() async {
        let regions = [
            TVRegion(bouquet: 4101, subBouquet: 1, name: "London", nation: "England", isHD: true),
            TVRegion(bouquet: 4109, subBouquet: 1, name: "Borders", nation: "Scotland", isHD: true),
            TVRegion(bouquet: 5000, subBouquet: 1, name: "Atlantis City", nation: "Atlantis", isHD: true)
        ]
        let viewModel = makeViewModel(
            channels: [
                channelPair(id: "ENG", bouquet: 4101, subBouquet: 1),
                channelPair(id: "SCO", bouquet: 4109, subBouquet: 1),
                channelPair(id: "ATL", bouquet: 5000, subBouquet: 1)
            ],
            regions: regions
        )

        await viewModel.load()

        // England, Scotland (preferred order), then the unknown nation last (alphabetical).
        #expect(viewModel.regionsByNation.map(\.nation) == ["England", "Scotland", "Atlantis"])
    }

    // MARK: - Helpers

    private func makeViewModel(
        channels: [Channel],
        regions: [TVRegion],
        persistedID: String? = nil,
        saveSelectedRegionID: @escaping @Sendable (String) -> Void = { _ in },
        onFetchChannels: @escaping @Sendable () -> Void = {},
        onFetchListings: @escaping @Sendable () -> Void = {}
    ) -> TVListingsViewModel {
        let programmes = channels.map { Self.programme(channelID: $0.id) }
        let nowDate = Self.now
        let dependencies = TVListingsDependencies(
            fetchChannels: { onFetchChannels(); return channels },
            fetchRegions: { regions },
            fetchListings: { onFetchListings(); return programmes },
            loadSelectedRegionID: { persistedID },
            saveSelectedRegionID: saveSelectedRegionID
        )
        return TVListingsViewModel(dependencies: dependencies, now: { nowDate })
    }

    /// Airing-now window is 1000–1900; `now` sits inside it.
    static let now = Date(timeIntervalSince1970: 1500)

    /// A channel carrying one England `(4097/4101, subBouquet)` SD+HD pair, or none when `subBouquet` is nil.
    private func channel(id: String, subBouquet: Int?) -> Channel {
        let regions = subBouquet.map {
            [ChannelRegion(bouquet: 4097, subBouquet: $0), ChannelRegion(bouquet: 4101, subBouquet: $0)]
        } ?? []
        return Channel(
            id: id,
            name: id,
            type: .television,
            isHD: false,
            logoURL: nil,
            channelNumbers: [ChannelNumber(channelNumber: "1", regions: regions)]
        )
    }

    private func channelPair(id: String, bouquet: Int, subBouquet: Int) -> Channel {
        Channel(
            id: id,
            name: id,
            type: .television,
            isHD: false,
            logoURL: nil,
            channelNumbers: [ChannelNumber(
                channelNumber: "1",
                regions: [ChannelRegion(bouquet: bouquet, subBouquet: subBouquet)]
            )]
        )
    }

    private func itemChannelIDs(_ viewModel: TVListingsViewModel) -> [String] {
        guard case .ready(let snapshot) = viewModel.viewState else {
            return []
        }
        return snapshot.items.map(\.channel.id)
    }

    static func programme(channelID: String) -> TVProgramme {
        TVProgramme(
            id: "\(channelID):now",
            channelID: channelID,
            title: "Now",
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
