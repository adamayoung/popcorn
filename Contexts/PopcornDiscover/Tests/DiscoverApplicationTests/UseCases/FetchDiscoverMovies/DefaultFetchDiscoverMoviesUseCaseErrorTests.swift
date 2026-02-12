//
//  DefaultFetchDiscoverMoviesUseCaseErrorTests.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import CoreDomainTestHelpers
@testable import DiscoverApplication
import DiscoverDomain
import Foundation
import Testing

@Suite("DefaultFetchDiscoverMoviesUseCase Error Cases")
struct DefaultFetchDiscoverMoviesUseCaseErrorTests {

    let mockRepository: MockDiscoverMovieRepository
    let mockGenreProvider: MockGenreProvider
    let mockAppConfigurationProvider: MockAppConfigurationProvider
    let mockLogoImageProvider: MockMovieLogoImageProvider

    init() {
        self.mockRepository = MockDiscoverMovieRepository()
        self.mockGenreProvider = MockGenreProvider()
        self.mockAppConfigurationProvider = MockAppConfigurationProvider()
        self.mockLogoImageProvider = MockMovieLogoImageProvider()
    }

    @Test("execute throws unauthorised error when repository throws unauthorised")
    func executeThrowsUnauthorisedErrorWhenRepositoryThrowsUnauthorised() async {
        mockRepository.moviesStub = .failure(.unauthorised)
        mockGenreProvider.movieGenresStub = .success(Genre.mocks)
        mockAppConfigurationProvider.appConfigurationStub = .success(AppConfiguration.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchDiscoverMoviesError else {
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
        mockRepository.moviesStub = .failure(.unknown(underlyingError))
        mockGenreProvider.movieGenresStub = .success(Genre.mocks)
        mockAppConfigurationProvider.appConfigurationStub = .success(AppConfiguration.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchDiscoverMoviesError else {
                    return false
                }
                if case .unknown = fetchError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws error when genre provider fails")
    func executeThrowsErrorWhenGenreProviderFails() async {
        mockRepository.moviesStub = .success(MoviePreview.mocks)
        mockGenreProvider.movieGenresStub = .failure(.unauthorised)
        mockAppConfigurationProvider.appConfigurationStub = .success(AppConfiguration.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchDiscoverMoviesError else {
                    return false
                }
                if case .unauthorised = fetchError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws error when app configuration provider fails")
    func executeThrowsErrorWhenAppConfigurationProviderFails() async {
        mockRepository.moviesStub = .success(MoviePreview.mocks)
        mockGenreProvider.movieGenresStub = .success(Genre.mocks)
        mockAppConfigurationProvider.appConfigurationStub = .failure(.unauthorised)

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchDiscoverMoviesError else {
                    return false
                }
                if case .unauthorised = fetchError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - Helpers

    private func makeUseCase() -> DefaultFetchDiscoverMoviesUseCase {
        DefaultFetchDiscoverMoviesUseCase(
            repository: mockRepository,
            genreProvider: mockGenreProvider,
            appConfigurationProvider: mockAppConfigurationProvider,
            logoImageProvider: mockLogoImageProvider
        )
    }

}
