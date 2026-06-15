//
//  DefaultFetchTVChannelsUseCaseFilteringTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsApplication
import TVListingsDomain

@Suite("DefaultFetchTVChannelsUseCase - SD/HD and Radio Filtering")
struct DefaultFetchTVChannelsUseCaseFilteringTests {

    let mockRepository = MockTVChannelRepository()

    // MARK: - SD/HD de-duplication

    @Test("execute keeps only the HD variant when a channel has both an SD and HD version")
    func executeKeepsOnlyHDVariantWhenBothExist() async throws {
        let bbcOneSD = TVChannel.mock(
            id: "BBC_ONE",
            name: "BBC One",
            isHD: false,
            channelNumbers: [TVChannelNumber(channelNumber: "1", regions: [])]
        )
        let bbcOneHD = TVChannel.mock(
            id: "BBC_ONE_HD",
            name: "BBC One HD",
            isHD: true,
            channelNumbers: [TVChannelNumber(channelNumber: "101", regions: [])]
        )
        mockRepository.channelsStub = .success([bbcOneSD, bbcOneHD])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["BBC_ONE_HD"])
    }

    @Test("execute keeps an SD channel that has no HD counterpart")
    func executeKeepsSDChannelWithoutHDCounterpart() async throws {
        let bbcOne = TVChannel.mock(
            id: "BBC_ONE",
            name: "BBC One",
            isHD: false,
            channelNumbers: [TVChannelNumber(channelNumber: "1", regions: [])]
        )
        let itvHD = TVChannel.mock(
            id: "ITV_HD",
            name: "ITV HD",
            isHD: true,
            channelNumbers: [TVChannelNumber(channelNumber: "3", regions: [])]
        )
        mockRepository.channelsStub = .success([bbcOne, itvHD])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["BBC_ONE", "ITV_HD"])
    }

    // MARK: - Radio station filtering

    @Test("execute filters out radio channels by type")
    func executeFiltersOutRadioStations() async throws {
        let classicFM = TVChannel.mock(id: "CLASSIC_FM", name: "Classic FM", type: .radio)
        let talkSport = TVChannel.mock(id: "TALKSPORT", name: "talkSPORT", type: .radio)
        let bbcOne = TVChannel.mock(
            id: "BBC_ONE",
            name: "BBC One",
            type: .television,
            channelNumbers: [TVChannelNumber(channelNumber: "101", regions: [])]
        )
        mockRepository.channelsStub = .success([classicFM, talkSport, bbcOne])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["BBC_ONE"])
    }

    @Test("execute keeps TV channels")
    func executeKeepsTVChannels() async throws {
        let tvChannel = TVChannel.mock(id: "TV", name: "A TV Channel", type: .television, channelNumbers: [])
        mockRepository.channelsStub = .success([tvChannel])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["TV"])
    }

    private func makeUseCase() -> DefaultFetchTVChannelsUseCase {
        DefaultFetchTVChannelsUseCase(tvChannelRepository: mockRepository)
    }

}
