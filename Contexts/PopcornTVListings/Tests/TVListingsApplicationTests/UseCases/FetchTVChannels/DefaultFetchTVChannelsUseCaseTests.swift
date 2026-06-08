//
//  DefaultFetchTVChannelsUseCaseTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsApplication
import TVListingsDomain

@Suite("DefaultFetchTVChannelsUseCase")
struct DefaultFetchTVChannelsUseCaseTests {

    let mockRepository = MockTVChannelRepository()

    @Test("execute returns channels on success")
    func executeReturnsChannelsOnSuccess() async throws {
        let bbc = TVChannel.mock(
            id: "BBC",
            channelNumbers: [TVChannelNumber(channelNumber: "1", subbouquetIDs: [])]
        )
        let itv = TVChannel.mock(
            id: "ITV",
            channelNumbers: [TVChannelNumber(channelNumber: "2", subbouquetIDs: [])]
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
        let itv = TVChannel.mock(
            id: "ITV",
            channelNumbers: [TVChannelNumber(channelNumber: "3", subbouquetIDs: [])]
        )
        let bbcOne = TVChannel.mock(
            id: "BBC_ONE",
            channelNumbers: [TVChannelNumber(channelNumber: "1", subbouquetIDs: [])]
        )
        let bbcTwo = TVChannel.mock(
            id: "BBC_TWO",
            channelNumbers: [TVChannelNumber(channelNumber: "2", subbouquetIDs: [])]
        )
        mockRepository.channelsStub = .success([itv, bbcTwo, bbcOne])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["BBC_ONE", "BBC_TWO", "ITV"])
    }

    @Test("execute sorts channels with multiple channel numbers by their lowest number")
    func executeSortsByLowestChannelNumberWhenMultiplePresent() async throws {
        let channelA = TVChannel.mock(
            id: "A",
            channelNumbers: [
                TVChannelNumber(channelNumber: "105", subbouquetIDs: []),
                TVChannelNumber(channelNumber: "5", subbouquetIDs: [])
            ]
        )
        let channelB = TVChannel.mock(
            id: "B",
            channelNumbers: [TVChannelNumber(channelNumber: "10", subbouquetIDs: [])]
        )
        mockRepository.channelsStub = .success([channelB, channelA])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["A", "B"])
    }

    @Test("execute sorts channel numbers numerically, not lexicographically")
    func executeSortsChannelNumbersNumerically() async throws {
        let channel9 = TVChannel.mock(
            id: "NINE",
            channelNumbers: [TVChannelNumber(channelNumber: "9", subbouquetIDs: [])]
        )
        let channel100 = TVChannel.mock(
            id: "ONE_HUNDRED",
            channelNumbers: [TVChannelNumber(channelNumber: "100", subbouquetIDs: [])]
        )
        mockRepository.channelsStub = .success([channel100, channel9])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["NINE", "ONE_HUNDRED"])
    }

    @Test("execute places channels with no channel numbers last")
    func executePlacesChannelsWithoutChannelNumbersLast() async throws {
        let unnumbered = TVChannel.mock(id: "UNNUMBERED", channelNumbers: [])
        let numbered = TVChannel.mock(
            id: "NUMBERED",
            channelNumbers: [TVChannelNumber(channelNumber: "50", subbouquetIDs: [])]
        )
        mockRepository.channelsStub = .success([unnumbered, numbered])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["NUMBERED", "UNNUMBERED"])
    }

    @Test("execute sorts channels whose numbers are all non-parseable last")
    func executeSortsChannelsWithNonParseableNumbersLast() async throws {
        let nonParseable = TVChannel.mock(
            id: "NON_PARSEABLE",
            channelNumbers: [TVChannelNumber(channelNumber: "HD", subbouquetIDs: [])]
        )
        let numbered = TVChannel.mock(
            id: "NUMBERED",
            channelNumbers: [TVChannelNumber(channelNumber: "50", subbouquetIDs: [])]
        )
        mockRepository.channelsStub = .success([nonParseable, numbered])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["NUMBERED", "NON_PARSEABLE"])
    }

    @Test("execute breaks ties on equal channel numbers by name then id")
    func executeBreaksTiesByNameThenID() async throws {
        let zeta = TVChannel.mock(
            id: "ZETA",
            name: "Zeta",
            channelNumbers: [TVChannelNumber(channelNumber: "5", subbouquetIDs: [])]
        )
        let alpha = TVChannel.mock(
            id: "ALPHA",
            name: "Alpha",
            channelNumbers: [TVChannelNumber(channelNumber: "5", subbouquetIDs: [])]
        )
        mockRepository.channelsStub = .success([zeta, alpha])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["ALPHA", "ZETA"])
    }

    @Test("execute breaks ties on equal channel number and equal name by id")
    func executeBreaksTiesByIDWhenNumberAndNameMatch() async throws {
        let channelB = TVChannel.mock(
            id: "B",
            name: "Same",
            channelNumbers: [TVChannelNumber(channelNumber: "5", subbouquetIDs: [])]
        )
        let channelA = TVChannel.mock(
            id: "A",
            name: "Same",
            channelNumbers: [TVChannelNumber(channelNumber: "5", subbouquetIDs: [])]
        )
        mockRepository.channelsStub = .success([channelB, channelA])

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.map(\.id) == ["A", "B"])
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
                guard let fetchError = error as? FetchTVChannelsError else {
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
                guard let fetchError = error as? FetchTVChannelsError else {
                    return false
                }
                if case .unknown = fetchError {
                    return true
                }
                return false
            }
        )
    }

    private func makeUseCase() -> DefaultFetchTVChannelsUseCase {
        DefaultFetchTVChannelsUseCase(tvChannelRepository: mockRepository)
    }

}
