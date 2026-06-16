//
//  TVRegionFilteringTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsDomain

@Suite("TVRegionFiltering")
struct TVRegionFilteringTests {

    // MARK: - groups

    @Test("collapses an area's HD and SD rows into one group with both pairs")
    func collapsesHDAndSDRowsIntoOneGroup() {
        let regions = [
            TVRegion(bouquet: 4101, subBouquet: 1, name: "London", nation: "England", isHD: true),
            TVRegion(bouquet: 4097, subBouquet: 1, name: "London", nation: "England", isHD: false)
        ]

        let groups = TVRegionFiltering.groups(from: regions)

        #expect(groups.count == 1)
        #expect(groups.first?.name == "London")
        #expect(groups.first?.nation == "England")
        #expect(groups.first?.id == "England#1")
        #expect(Set(groups.first?.pairs ?? []) == [
            ChannelRegion(bouquet: 4101, subBouquet: 1),
            ChannelRegion(bouquet: 4097, subBouquet: 1)
        ])
    }

    @Test("keeps same subBouquet in different nations as distinct groups")
    func keepsSameSubBouquetInDifferentNationsDistinct() {
        let regions = [
            TVRegion(bouquet: 4101, subBouquet: 1, name: "London", nation: "England", isHD: true),
            TVRegion(bouquet: 4109, subBouquet: 1, name: "Borders", nation: "Scotland", isHD: true)
        ]

        let groups = TVRegionFiltering.groups(from: regions)

        #expect(groups.map(\.id) == ["Scotland#1", "England#1"], "sorted by name: Borders before London")
    }

    @Test("groups returns empty for no regions")
    func groupsReturnsEmptyForNoRegions() {
        #expect(TVRegionFiltering.groups(from: []).isEmpty)
    }

    // MARK: - channels(in:)

    @Test("a channel matches an area when a channel-number region matches one of its pairs")
    func channelMatchesAreaByPair() {
        let london = TVRegionGroup(
            nation: "England",
            name: "London",
            subBouquet: 1,
            pairs: [ChannelRegion(bouquet: 4101, subBouquet: 1), ChannelRegion(bouquet: 4097, subBouquet: 1)]
        )
        let inLondon = Self.channel(
            id: "IN",
            regions: [ChannelRegion(bouquet: 4097, subBouquet: 1)]
        )
        let notInLondon = Self.channel(
            id: "OUT",
            regions: [ChannelRegion(bouquet: 4105, subBouquet: 9)]
        )

        let result = TVRegionFiltering.channels([inLondon, notInLondon], in: london)

        #expect(result.map(\.id) == ["IN"])
    }

    @Test("matching is nation-safe: a Scotland pair does not match a London area")
    func matchingIsNationSafe() {
        let london = TVRegionGroup(
            nation: "England",
            name: "London",
            subBouquet: 1,
            pairs: [ChannelRegion(bouquet: 4101, subBouquet: 1), ChannelRegion(bouquet: 4097, subBouquet: 1)]
        )
        // Same subBouquet (1) but a Scotland bouquet — must NOT match London.
        let scottish = Self.channel(id: "STV", regions: [ChannelRegion(bouquet: 4109, subBouquet: 1)])

        #expect(TVRegionFiltering.channels([scottish], in: london).isEmpty)
    }

    @Test("a channel with no channel-number regions matches no area")
    func channelWithNoRegionsMatchesNothing() {
        let london = TVRegionGroup(
            nation: "England",
            name: "London",
            subBouquet: 1,
            pairs: [ChannelRegion(bouquet: 4101, subBouquet: 1)]
        )
        let noRegions = Self.channel(id: "X", regions: [])

        #expect(TVRegionFiltering.channels([noRegions], in: london).isEmpty)
    }

    private static func channel(id: String, regions: [ChannelRegion]) -> Channel {
        Channel(
            id: id,
            name: id,
            type: .television,
            isHD: false,
            logoURL: nil,
            channelNumbers: [ChannelNumber(channelNumber: "1", regions: regions)]
        )
    }

}
