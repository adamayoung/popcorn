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
        let channels = [TVChannel.mock(id: "BBC"), TVChannel.mock(id: "ITV")]
        mockRepository.channelsStub = .success(channels)

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result == channels)
        #expect(mockRepository.channelsCallCount == 1)
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
