//
//  DefaultFetchChannelsUseCaseTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsApplication
import TVListingsDomain

@Suite("DefaultFetchChannelsUseCase")
struct DefaultFetchChannelsUseCaseTests {

    let mockRepository = MockChannelRepository()

    @Test("execute returns channels on success")
    func executeReturnsChannelsOnSuccess() async throws {
        let bbc = Channel.mock(
            id: "BBC",
            channelNumbers: [ChannelNumber(channelNumber: "1", regions: [])]
        )
        let itv = Channel.mock(
            id: "ITV",
            channelNumbers: [ChannelNumber(channelNumber: "2", regions: [])]
        )
        let channels = [bbc, itv]
        mockRepository.channelsStub = .success(channels)

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result == channels)
        #expect(mockRepository.channelsCallCount == 1)
    }

    @Test("execute returns channels sorted by ascending channel number")
    func executeReturnsChannelsSortedByChannelNumber() async throws {
        let itv = Channel.mock(
            id: "ITV",
            channelNumbers: [ChannelNumber(channelNumber: "3", regions: [])]
        )
        let bbcOne = Channel.mock(
            id: "BBC_ONE",
            channelNumbers: [ChannelNumber(channelNumber: "1", regions: [])]
        )
        let bbcTwo = Channel.mock(
            id: "BBC_TWO",
            channelNumbers: [ChannelNumber(channelNumber: "2", regions: [])]
        )
        mockRepository.channelsStub = .success([itv, bbcTwo, bbcOne])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["BBC_ONE", "BBC_TWO", "ITV"])
    }

    @Test("execute sorts channels with multiple channel numbers by their lowest number")
    func executeSortsByLowestChannelNumberWhenMultiplePresent() async throws {
        let channelA = Channel.mock(
            id: "A",
            channelNumbers: [
                ChannelNumber(channelNumber: "105", regions: []),
                ChannelNumber(channelNumber: "5", regions: [])
            ]
        )
        let channelB = Channel.mock(
            id: "B",
            channelNumbers: [ChannelNumber(channelNumber: "10", regions: [])]
        )
        mockRepository.channelsStub = .success([channelB, channelA])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["A", "B"])
    }

    @Test("execute sorts channel numbers numerically, not lexicographically")
    func executeSortsChannelNumbersNumerically() async throws {
        let channel9 = Channel.mock(
            id: "NINE",
            channelNumbers: [ChannelNumber(channelNumber: "9", regions: [])]
        )
        let channel100 = Channel.mock(
            id: "ONE_HUNDRED",
            channelNumbers: [ChannelNumber(channelNumber: "100", regions: [])]
        )
        mockRepository.channelsStub = .success([channel100, channel9])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["NINE", "ONE_HUNDRED"])
    }

    @Test("execute places channels with no channel numbers last")
    func executePlacesChannelsWithoutChannelNumbersLast() async throws {
        let unnumbered = Channel.mock(id: "UNNUMBERED", channelNumbers: [])
        let numbered = Channel.mock(
            id: "NUMBERED",
            channelNumbers: [ChannelNumber(channelNumber: "50", regions: [])]
        )
        mockRepository.channelsStub = .success([unnumbered, numbered])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["NUMBERED", "UNNUMBERED"])
    }

    @Test("execute sorts channels whose numbers are all non-parseable last")
    func executeSortsChannelsWithNonParseableNumbersLast() async throws {
        let nonParseable = Channel.mock(
            id: "NON_PARSEABLE",
            channelNumbers: [ChannelNumber(channelNumber: "HD", regions: [])]
        )
        let numbered = Channel.mock(
            id: "NUMBERED",
            channelNumbers: [ChannelNumber(channelNumber: "50", regions: [])]
        )
        mockRepository.channelsStub = .success([nonParseable, numbered])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["NUMBERED", "NON_PARSEABLE"])
    }

    @Test("execute uses the parseable minimum from mixed channel numbers")
    func executeUsesParseableMinimumFromMixedChannelNumbers() async throws {
        let mixed = Channel.mock(
            id: "MIXED",
            channelNumbers: [
                ChannelNumber(channelNumber: "HD", regions: []),
                ChannelNumber(channelNumber: "5", regions: [])
            ]
        )
        let numbered = Channel.mock(
            id: "NUMBERED",
            channelNumbers: [ChannelNumber(channelNumber: "10", regions: [])]
        )
        mockRepository.channelsStub = .success([numbered, mixed])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["MIXED", "NUMBERED"])
    }

    @Test("execute breaks ties on equal channel numbers by name then id")
    func executeBreaksTiesByNameThenID() async throws {
        let zeta = Channel.mock(
            id: "ZETA",
            name: "Zeta",
            channelNumbers: [ChannelNumber(channelNumber: "5", regions: [])]
        )
        let alpha = Channel.mock(
            id: "ALPHA",
            name: "Alpha",
            channelNumbers: [ChannelNumber(channelNumber: "5", regions: [])]
        )
        mockRepository.channelsStub = .success([zeta, alpha])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["ALPHA", "ZETA"])
    }

    @Test("execute breaks ties on equal channel number and equal name by id")
    func executeBreaksTiesByIDWhenNumberAndNameMatch() async throws {
        let channelB = Channel.mock(
            id: "B",
            name: "Same",
            channelNumbers: [ChannelNumber(channelNumber: "5", regions: [])]
        )
        let channelA = Channel.mock(
            id: "A",
            name: "Same",
            channelNumbers: [ChannelNumber(channelNumber: "5", regions: [])]
        )
        mockRepository.channelsStub = .success([channelB, channelA])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["A", "B"])
    }

    @Test("execute breaks ties between two unnumbered channels by name then id")
    func executeBreaksTiesBetweenUnnumberedChannelsByNameThenID() async throws {
        let zeta = Channel.mock(id: "ZETA", name: "Zeta", channelNumbers: [])
        let alpha = Channel.mock(id: "ALPHA", name: "Alpha", channelNumbers: [])
        mockRepository.channelsStub = .success([zeta, alpha])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["ALPHA", "ZETA"])
    }

    @Test("execute throws local when repository throws local")
    func executeThrowsLocalWhenRepositoryThrowsLocal() async {
        mockRepository.channelsStub = .failure(.local(nil))

        let useCase = makeUseCase()

        await #expect(
            performing: {
                _ = try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchChannelsError else {
                    return false
                }
                if case .local = fetchError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws unknown when repository throws remote or unknown")
    func executeThrowsUnknownWhenRepositoryThrowsRemoteOrUnknown() async {
        mockRepository.channelsStub = .failure(.remote(nil))

        let useCase = makeUseCase()

        await #expect(
            performing: {
                _ = try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchChannelsError else {
                    return false
                }
                if case .unknown = fetchError {
                    return true
                }
                return false
            }
        )
    }

    private func makeUseCase() -> DefaultFetchChannelsUseCase {
        DefaultFetchChannelsUseCase(channelRepository: mockRepository)
    }

}
