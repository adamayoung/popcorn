//
//  DefaultFetchTVChannelScheduleUseCaseTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsApplication
import TVListingsDomain

@Suite("DefaultFetchTVChannelScheduleUseCase")
struct DefaultFetchTVChannelScheduleUseCaseTests {

    let mockRepository = MockTVProgrammeRepository()

    @Test("execute returns programmes for the requested channel and date")
    func executeReturnsProgrammesForTheRequestedChannelAndDate() async throws {
        let programmes = [
            TVProgramme.mock(channelID: "BBC", offset: 0),
            TVProgramme.mock(channelID: "BBC", offset: 1800)
        ]
        mockRepository.programmesStub = .success(programmes)

        let useCase = makeUseCase()
        let date = Date(timeIntervalSince1970: 1_776_463_200)

        let result = try await useCase.execute(channelID: "BBC", date: date)

        #expect(result == programmes)
        #expect(mockRepository.programmesCallCount == 1)
        #expect(mockRepository.programmesCalledWith.first?.channelID == "BBC")
        #expect(mockRepository.programmesCalledWith.first?.date == date)
    }

    @Test("execute throws local when repository throws local")
    func executeThrowsLocalWhenRepositoryThrowsLocal() async {
        mockRepository.programmesStub = .failure(.local(nil))

        let useCase = makeUseCase()

        await #expect(
            performing: {
                _ = try await useCase.execute(channelID: "BBC", date: .now)
            },
            throws: { error in
                guard let fetchError = error as? FetchTVChannelScheduleError else {
                    return false
                }
                if case .local = fetchError {
                    return true
                }
                return false
            }
        )
    }

    private func makeUseCase() -> DefaultFetchTVChannelScheduleUseCase {
        DefaultFetchTVChannelScheduleUseCase(tvProgrammeRepository: mockRepository)
    }

}
