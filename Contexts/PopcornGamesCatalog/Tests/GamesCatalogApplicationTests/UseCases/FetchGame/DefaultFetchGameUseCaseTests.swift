//
//  DefaultFetchGameUseCaseTests.swift
//  PopcornGamesCatalog
//
//  Copyright © 2025 Adam Young.
//

import Foundation
@testable import GamesCatalogApplication
import GamesCatalogDomain
import Testing

@Suite("DefaultFetchGameUseCase")
struct DefaultFetchGameUseCaseTests {

    let mockRepository: MockGameRepository

    init() {
        self.mockRepository = MockGameRepository()
    }

    // MARK: - Success Cases

    @Test("execute returns game metadata on success")
    func executeReturnsGameMetadataOnSuccess() async throws {
        let expectedGame = GameMetadata.mock(id: 1, name: "Plot Remix")
        mockRepository.gameStub = .success(expectedGame)

        let useCase = DefaultFetchGameUseCase(repository: mockRepository)

        let result = try await useCase.execute(id: 1)

        #expect(result.id == expectedGame.id)
        #expect(result.name == expectedGame.name)
        #expect(mockRepository.gameCallCount == 1)
    }

    @Test("execute passes correct ID to repository")
    func executePassesCorrectIDToRepository() async throws {
        let game = GameMetadata.mock(id: 42)
        mockRepository.gameStub = .success(game)

        let useCase = DefaultFetchGameUseCase(repository: mockRepository)

        _ = try await useCase.execute(id: 42)

        #expect(mockRepository.gameCalledWith[0] == 42)
    }

    // MARK: - Error Cases

    @Test("execute throws notFound error when repository throws notFound")
    func executeThrowsNotFoundErrorWhenRepositoryThrowsNotFound() async {
        mockRepository.gameStub = .failure(.notFound)

        let useCase = DefaultFetchGameUseCase(repository: mockRepository)

        await #expect(
            performing: {
                try await useCase.execute(id: 999)
            },
            throws: { error in
                guard let fetchError = error as? FetchGameError else {
                    return false
                }
                if case .notFound = fetchError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws unknown error when repository throws unknown")
    func executeThrowsUnknownErrorWhenRepositoryThrowsUnknown() async {
        let underlyingError = NSError(domain: "test", code: 123)
        mockRepository.gameStub = .failure(.unknown(underlyingError))

        let useCase = DefaultFetchGameUseCase(repository: mockRepository)

        await #expect(
            performing: {
                try await useCase.execute(id: 1)
            },
            throws: { error in
                guard let fetchError = error as? FetchGameError else {
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
