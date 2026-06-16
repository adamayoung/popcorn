//
//  DefaultFetchChannelsUseCaseFilteringTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsApplication
import TVListingsDomain

@Suite("DefaultFetchChannelsUseCase - SD/HD and Radio Filtering")
struct DefaultFetchChannelsUseCaseFilteringTests {

    let mockRepository = MockChannelRepository()

    // MARK: - SD/HD de-duplication

    @Test("execute keeps only the HD variant when a channel has both an SD and HD version")
    func executeKeepsOnlyHDVariantWhenBothExist() async throws {
        let bbcOneSD = Channel.mock(
            id: "BBC_ONE",
            name: "BBC One",
            isHD: false,
            channelNumbers: [ChannelNumber(channelNumber: "1", regions: [])]
        )
        let bbcOneHD = Channel.mock(
            id: "BBC_ONE_HD",
            name: "BBC One HD",
            isHD: true,
            channelNumbers: [ChannelNumber(channelNumber: "101", regions: [])]
        )
        mockRepository.channelsStub = .success([bbcOneSD, bbcOneHD])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["BBC_ONE_HD"])
    }

    @Test("execute keeps an SD channel that has no HD counterpart")
    func executeKeepsSDChannelWithoutHDCounterpart() async throws {
        let bbcOne = Channel.mock(
            id: "BBC_ONE",
            name: "BBC One",
            isHD: false,
            channelNumbers: [ChannelNumber(channelNumber: "1", regions: [])]
        )
        let itvHD = Channel.mock(
            id: "ITV_HD",
            name: "ITV HD",
            isHD: true,
            channelNumbers: [ChannelNumber(channelNumber: "3", regions: [])]
        )
        mockRepository.channelsStub = .success([bbcOne, itvHD])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["BBC_ONE", "ITV_HD"])
    }

    // MARK: - Radio station filtering

    @Test("execute filters out radio channels by type")
    func executeFiltersOutRadioStations() async throws {
        let classicFM = Channel.mock(id: "CLASSIC_FM", name: "Classic FM", type: .radio)
        let talkSport = Channel.mock(id: "TALKSPORT", name: "talkSPORT", type: .radio)
        let bbcOne = Channel.mock(
            id: "BBC_ONE",
            name: "BBC One",
            type: .television,
            channelNumbers: [ChannelNumber(channelNumber: "101", regions: [])]
        )
        mockRepository.channelsStub = .success([classicFM, talkSport, bbcOne])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["BBC_ONE"])
    }

    @Test("execute keeps TV channels")
    func executeKeepsChannels() async throws {
        let channel = Channel.mock(id: "TV", name: "A TV Channel", type: .television, channelNumbers: [])
        mockRepository.channelsStub = .success([channel])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["TV"])
    }

    private func makeUseCase() -> DefaultFetchChannelsUseCase {
        DefaultFetchChannelsUseCase(channelRepository: mockRepository)
    }

}
