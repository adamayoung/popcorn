//
//  DefaultFetchGamesUseCaseTests.swift
//  PopcornGamesCatalog
//
//  Copyright © 2025 Adam Young.
//

import Foundation
@testable import GamesCatalogApplication
import GamesCatalogDomain
import Testing

@Suite("DefaultFetchGamesUseCase")
struct DefaultFetchGamesUseCaseTests {

    let mockRepository: MockGameRepository

    init() {
        self.mockRepository = MockGameRepository()
    }

    // MARK: - Success Cases

    @Test("execute returns games on success")
    func executeReturnsGamesOnSuccess() async throws {
        let expectedGames = GameMetadata.mocks
        mockRepository.gamesStub = .success(expectedGames)

        let useCase = DefaultFetchGamesUseCase(repository: mockRepository)

        let result = try await useCase.execute()

        #expect(result.count == expectedGames.count)
        #expect(mockRepository.gamesCallCount == 1)
    }

    @Test("execute returns empty array when repository returns empty")
    func executeReturnsEmptyArrayWhenRepositoryReturnsEmpty() async throws {
        mockRepository.gamesStub = .success([])

        let useCase = DefaultFetchGamesUseCase(repository: mockRepository)

        let result = try await useCase.execute()

        #expect(result.isEmpty)
        #expect(mockRepository.gamesCallCount == 1)
    }

    // MARK: - Error Cases

    @Test("execute throws unknown error when repository throws unknown")
    func executeThrowsUnknownErrorWhenRepositoryThrowsUnknown() async {
        let underlyingError = NSError(domain: "test", code: 123)
        mockRepository.gamesStub = .failure(.unknown(underlyingError))

        let useCase = DefaultFetchGamesUseCase(repository: mockRepository)

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchGamesError else {
                    return false
                }
                if case .unknown = fetchError {
                    return true
                }
                return false
            }
        )
    }

}
