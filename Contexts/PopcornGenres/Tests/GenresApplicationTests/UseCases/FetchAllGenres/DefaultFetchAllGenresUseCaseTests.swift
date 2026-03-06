//
//  DefaultFetchAllGenresUseCaseTests.swift
//  PopcornGenres
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import CoreDomainTestHelpers
import Foundation
@testable import GenresApplication
import GenresDomain
import Testing

@Suite("DefaultFetchAllGenresUseCase")
struct DefaultFetchAllGenresUseCaseTests {

    let mockRepository: MockGenreRepository
    let mockAppConfigurationProvider: MockAppConfigurationProvider
    let mockGenreBackdropProvider: MockGenreBackdropProvider

    init() {
        self.mockRepository = MockGenreRepository()
        self.mockAppConfigurationProvider = MockAppConfigurationProvider()
        self.mockGenreBackdropProvider = MockGenreBackdropProvider()
    }

    private func makeUseCase() -> DefaultFetchAllGenresUseCase {
        DefaultFetchAllGenresUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigurationProvider,
            genreBackdropProvider: mockGenreBackdropProvider
        )
    }

    // MARK: - Success Cases

    @Test("execute returns merged genres with backdrops and colors")
    func executeReturnsMergedGenresWithBackdropsAndColors() async throws {
        let movieGenres = [Genre.mock(id: 28, name: "Action")]
        let tvGenres = [Genre.mock(id: 10765, name: "Sci-Fi & Fantasy")]
        mockRepository.movieGenresStub = .success(movieGenres)
        mockRepository.tvSeriesGenresStub = .success(tvGenres)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())
        mockGenreBackdropProvider.backdropPathStubs = try [
            28: #require(URL(string: "/action.jpg")),
            10765: #require(URL(string: "/scifi.jpg"))
        ]

        let result = try await makeUseCase().execute()

        #expect(result.count == 2)
        #expect(result.allSatisfy { $0.backdropURLSet != nil })
        #expect(result.allSatisfy { $0.color.red >= 0 })
    }

    @Test("execute deduplicates genres by ID")
    func executeDeduplicatesGenresByID() async throws {
        let movieGenres = [Genre.mock(id: 28, name: "Action")]
        let tvGenres = [Genre.mock(id: 28, name: "Action")]
        mockRepository.movieGenresStub = .success(movieGenres)
        mockRepository.tvSeriesGenresStub = .success(tvGenres)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let result = try await makeUseCase().execute()

        #expect(result.count == 1)
        #expect(result[0].id == 28)
    }

    @Test("execute sorts genres alphabetically")
    func executeSortsGenresAlphabetically() async throws {
        let movieGenres = [
            Genre.mock(id: 28, name: "Action"),
            Genre.mock(id: 35, name: "Comedy")
        ]
        let tvGenres = [Genre.mock(id: 12, name: "Adventure")]
        mockRepository.movieGenresStub = .success(movieGenres)
        mockRepository.tvSeriesGenresStub = .success(tvGenres)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let result = try await makeUseCase().execute()

        #expect(result.map(\.name) == ["Action", "Adventure", "Comedy"])
    }

    @Test("execute assigns deterministic color")
    func executeAssignsDeterministicColor() async throws {
        let movieGenres = [Genre.mock(id: 28, name: "Action")]
        mockRepository.movieGenresStub = .success(movieGenres)
        mockRepository.tvSeriesGenresStub = .success([])
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let result1 = try await makeUseCase().execute()
        let result2 = try await makeUseCase().execute()

        #expect(result1[0].color == result2[0].color)
    }

    @Test("execute handles empty genre lists")
    func executeHandlesEmptyGenreLists() async throws {
        mockRepository.movieGenresStub = .success([])
        mockRepository.tvSeriesGenresStub = .success([])
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let result = try await makeUseCase().execute()

        #expect(result.isEmpty)
    }

    @Test("execute returns genre with nil backdrop when provider returns nil")
    func executeReturnsGenreWithNilBackdropWhenProviderReturnsNil() async throws {
        let movieGenres = [Genre.mock(id: 28, name: "Action")]
        mockRepository.movieGenresStub = .success(movieGenres)
        mockRepository.tvSeriesGenresStub = .success([])
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let result = try await makeUseCase().execute()

        #expect(result.count == 1)
        #expect(result[0].backdropURLSet == nil)
    }

    @Test("execute handles backdrop provider error gracefully")
    func executeHandlesBackdropProviderErrorGracefully() async throws {
        let movieGenres = [Genre.mock(id: 28, name: "Action")]
        mockRepository.movieGenresStub = .success(movieGenres)
        mockRepository.tvSeriesGenresStub = .success([])
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())
        mockGenreBackdropProvider.backdropPathError = .unknown(nil)

        let result = try await makeUseCase().execute()

        #expect(result.count == 1)
        #expect(result[0].backdropURLSet == nil)
    }

    // MARK: - Error Cases

    @Test("execute throws unauthorised when repository throws unauthorised")
    func executeThrowsUnauthorisedWhenRepositoryThrowsUnauthorised() async {
        mockRepository.movieGenresStub = .failure(.unauthorised)
        mockRepository.tvSeriesGenresStub = .success([])
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        await #expect(
            performing: {
                try await makeUseCase().execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchAllGenresError else {
                    return false
                }
                if case .unauthorised = fetchError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws unknown when repository throws unknown")
    func executeThrowsUnknownWhenRepositoryThrowsUnknown() async {
        let underlyingError = NSError(domain: "test", code: 123)
        mockRepository.movieGenresStub = .failure(.unknown(underlyingError))
        mockRepository.tvSeriesGenresStub = .success([])
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        await #expect(
            performing: {
                try await makeUseCase().execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchAllGenresError else {
                    return false
                }
                if case .unknown = fetchError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws error when app config fails")
    func executeThrowsErrorWhenAppConfigFails() async {
        mockRepository.movieGenresStub = .success([Genre.mock()])
        mockRepository.tvSeriesGenresStub = .success([])
        mockAppConfigurationProvider.appConfigurationStub = .failure(.unauthorised)

        await #expect(
            performing: {
                try await makeUseCase().execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchAllGenresError else {
                    return false
                }
                if case .unauthorised = fetchError {
                    return true
                }
                return false
            }
        )
    }

}
