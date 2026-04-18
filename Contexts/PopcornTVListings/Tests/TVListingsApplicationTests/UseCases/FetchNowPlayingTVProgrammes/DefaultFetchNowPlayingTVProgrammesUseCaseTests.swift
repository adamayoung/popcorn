//
//  DefaultFetchNowPlayingTVProgrammesUseCaseTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsApplication
import TVListingsDomain

@Suite("DefaultFetchNowPlayingTVProgrammesUseCase")
struct DefaultFetchNowPlayingTVProgrammesUseCaseTests {

    let mockRepository = MockTVProgrammeRepository()

    @Test("execute returns programmes from the repository")
    func executeReturnsProgrammesFromTheRepository() async throws {
        let programmes = [TVProgramme.mock(channelID: "BBC", offset: 0)]
        mockRepository.nowPlayingStub = .success(programmes)

        let useCase = makeUseCase(now: { Date(timeIntervalSince1970: 1_776_463_200) })

        let result = try await useCase.execute()

        #expect(result == programmes)
        #expect(mockRepository.nowPlayingCallCount == 1)
    }

    @Test("execute passes injected now value to the repository")
    func executePassesInjectedNowToRepository() async throws {
        mockRepository.nowPlayingStub = .success([])
        let fixedNow = Date(timeIntervalSince1970: 1_776_463_200)

        let useCase = makeUseCase(now: { fixedNow })

        _ = try await useCase.execute()

        #expect(mockRepository.nowPlayingCalledWith.first == fixedNow)
    }

    @Test("execute throws local when repository throws local")
    func executeThrowsLocalWhenRepositoryThrowsLocal() async {
        mockRepository.nowPlayingStub = .failure(.local(nil))

        let useCase = makeUseCase(now: { .now })

        await #expect(
            performing: {
                _ = try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchNowPlayingTVProgrammesError else {
                    return false
                }
                if case .local = fetchError {
                    return true
                }
                return false
            }
        )
    }

    private func makeUseCase(now: @escaping @Sendable () -> Date) -> DefaultFetchNowPlayingTVProgrammesUseCase {
        DefaultFetchNowPlayingTVProgrammesUseCase(tvProgrammeRepository: mockRepository, now: now)
    }

}
