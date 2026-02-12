//
//  DefaultFetchMovieGenresUseCaseTests.swift
//  PopcornGenres
//
//  Copyright © 2025 Adam Young.
//

import Foundation
@testable import GenresApplication
import GenresDomain
import Testing

@Suite("DefaultFetchMovieGenresUseCase")
struct DefaultFetchMovieGenresUseCaseTests {

    let mockRepository: MockGenreRepository

    init() {
        self.mockRepository = MockGenreRepository()
    }

    // MARK: - Success Cases

    @Test("execute returns genres on success")
    func executeReturnsGenresOnSuccess() async throws {
        let expectedGenres = Genre.mocks
        mockRepository.movieGenresStub = .success(expectedGenres)

        let useCase = DefaultFetchMovieGenresUseCase(repository: mockRepository)

        let result = try await useCase.execute()

        #expect(result == expectedGenres)
        #expect(mockRepository.movieGenresCallCount == 1)
    }

    @Test("execute returns empty array when repository returns empty")
    func executeReturnsEmptyArrayWhenRepositoryReturnsEmpty() async throws {
        mockRepository.movieGenresStub = .success([])

        let useCase = DefaultFetchMovieGenresUseCase(repository: mockRepository)

        let result = try await useCase.execute()

        #expect(result.isEmpty)
        #expect(mockRepository.movieGenresCallCount == 1)
    }

    // MARK: - Error Cases

    @Test("execute throws unauthorised error when repository throws unauthorised")
    func executeThrowsUnauthorisedErrorWhenRepositoryThrowsUnauthorised() async {
        mockRepository.movieGenresStub = .failure(.unauthorised)

        let useCase = DefaultFetchMovieGenresUseCase(repository: mockRepository)

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchMovieGenresError else {
                    return false
                }
                if case .unauthorised = fetchError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws unknown error when repository throws unknown")
    func executeThrowsUnknownErrorWhenRepositoryThrowsUnknown() async {
        let underlyingError = NSError(domain: "test", code: 123)
        mockRepository.movieGenresStub = .failure(.unknown(underlyingError))

        let useCase = DefaultFetchMovieGenresUseCase(repository: mockRepository)

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchMovieGenresError else {
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
