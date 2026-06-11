//
//  DefaultFetchTVListingsUseCaseTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsApplication
import TVListingsDomain

@Suite("DefaultFetchTVListingsUseCase")
struct DefaultFetchTVListingsUseCaseTests {

    let mockRepository = MockTVProgrammeRepository()

    @Test("execute returns programmes from the repository")
    func executeReturnsProgrammesFromTheRepository() async throws {
        let programmes = [TVProgramme.mock(channelID: "BBC", offset: 0)]
        mockRepository.programmesFromToStub = .success(programmes)

        let useCase = makeUseCase(now: { Date(timeIntervalSince1970: 1_776_463_200) })

        let result = try await useCase.execute()

        #expect(result == programmes)
        #expect(mockRepository.programmesFromToCallCount == 1)
    }

    @Test("execute requests a window of from == now and to == now + 3 days")
    func executeRequestsThreeDayWindowFromNow() async throws {
        mockRepository.programmesFromToStub = .success([])
        let fixedNow = Date(timeIntervalSince1970: 1_776_463_200)

        let useCase = makeUseCase(now: { fixedNow })

        _ = try await useCase.execute()

        let recorded = try #require(mockRepository.programmesFromToCalledWith.first)
        #expect(recorded.from == fixedNow)
        #expect(recorded.to == fixedNow.addingTimeInterval(3 * 86400))
        #expect(recorded.to > recorded.from)
    }

    @Test("execute throws local when repository throws local")
    func executeThrowsLocalWhenRepositoryThrowsLocal() async {
        mockRepository.programmesFromToStub = .failure(.local(nil))

        let useCase = makeUseCase(now: { .now })

        await #expect(
            performing: {
                _ = try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchTVListingsError else {
                    return false
                }
                if case .local = fetchError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws unknown when repository throws unknown")
    func executeThrowsUnknownWhenRepositoryThrowsUnknown() async {
        mockRepository.programmesFromToStub = .failure(.unknown(nil))

        let useCase = makeUseCase(now: { .now })

        await #expect(
            performing: {
                _ = try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchTVListingsError else {
                    return false
                }
                if case .unknown = fetchError {
                    return true
                }
                return false
            }
        )
    }

    private func makeUseCase(now: @escaping @Sendable () -> Date) -> DefaultFetchTVListingsUseCase {
        DefaultFetchTVListingsUseCase(tvProgrammeRepository: mockRepository, now: now)
    }

}
