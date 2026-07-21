//
//  DefaultFetchDiscoverMoviesUseCaseTests.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import CoreDomainTestHelpers
@testable import DiscoverApplication
import DiscoverDomain
import Foundation
import Testing

@Suite("DefaultFetchDiscoverMoviesUseCase")
struct DefaultFetchDiscoverMoviesUseCaseTests {

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

    @Test("execute returns movie preview details on success")
    func executeReturnsMoviePreviewDetailsOnSuccess() async throws {
        let moviePreviews = MoviePreview.mocks
        let genres = Genre.mocks
        let appConfiguration = AppConfiguration.mock()

        mockRepository.moviesStub = .success(page(moviePreviews))
        mockGenreProvider.movieGenresStub = .success(genres)
        mockAppConfigurationProvider.appConfigurationStub = .success(appConfiguration)
        mockLogoImageProvider.imageURLSetStub = .success(nil)

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.movies.count == moviePreviews.count)
        #expect(mockRepository.moviesCallCount == 1)
        #expect(mockGenreProvider.movieGenresCallCount == 1)
        #expect(mockAppConfigurationProvider.appConfigurationCallCount == 1)
    }

    @Test("execute returns a page preserving the repository page metadata")
    func executePreservesPageMetadata() async throws {
        let moviePreviews = MoviePreview.mocks

        mockRepository.moviesStub = .success(page(moviePreviews, page: 3, totalPages: 7))
        mockGenreProvider.movieGenresStub = .success(Genre.mocks)
        mockAppConfigurationProvider.appConfigurationStub = .success(AppConfiguration.mock())
        mockLogoImageProvider.imageURLSetStub = .success(nil)

        let useCase = makeUseCase()

        let result = try await useCase.execute(page: 3)

        #expect(result.page == 3)
        #expect(result.totalPages == 7)
        #expect(result.movies.count == moviePreviews.count)
    }

    @Test("execute with filter passes filter to repository")
    func executeWithFilterPassesFilterToRepository() async throws {
        let moviePreviews = MoviePreview.mocks
        let genres = Genre.mocks
        let appConfiguration = AppConfiguration.mock()
        let filter = MovieFilter(originalLanguage: "en", genres: [28])

        mockRepository.moviesStub = .success(page(moviePreviews))
        mockGenreProvider.movieGenresStub = .success(genres)
        mockAppConfigurationProvider.appConfigurationStub = .success(appConfiguration)
        mockLogoImageProvider.imageURLSetStub = .success(nil)

        let useCase = makeUseCase()

        _ = try await useCase.execute(filter: filter)

        #expect(mockRepository.moviesCallCount == 1)
        #expect(mockRepository.moviesCalledWith[0].filter?.originalLanguage == "en")
        #expect(mockRepository.moviesCalledWith[0].filter?.genres == [28])
    }

    @Test("execute with page passes page to repository")
    func executeWithPagePassesPageToRepository() async throws {
        let moviePreviews = MoviePreview.mocks
        let genres = Genre.mocks
        let appConfiguration = AppConfiguration.mock()

        mockRepository.moviesStub = .success(page(moviePreviews, page: 5, totalPages: 10))
        mockGenreProvider.movieGenresStub = .success(genres)
        mockAppConfigurationProvider.appConfigurationStub = .success(appConfiguration)
        mockLogoImageProvider.imageURLSetStub = .success(nil)

        let useCase = makeUseCase()

        _ = try await useCase.execute(page: 5)

        #expect(mockRepository.moviesCallCount == 1)
        #expect(mockRepository.moviesCalledWith[0].page == 5)
    }

    @Test("execute with filter and page passes both to repository")
    func executeWithFilterAndPagePassesBothToRepository() async throws {
        let moviePreviews = MoviePreview.mocks
        let genres = Genre.mocks
        let appConfiguration = AppConfiguration.mock()
        let filter = MovieFilter(originalLanguage: "fr", genres: nil)

        mockRepository.moviesStub = .success(page(moviePreviews, page: 3, totalPages: 8))
        mockGenreProvider.movieGenresStub = .success(genres)
        mockAppConfigurationProvider.appConfigurationStub = .success(appConfiguration)
        mockLogoImageProvider.imageURLSetStub = .success(nil)

        let useCase = makeUseCase()

        _ = try await useCase.execute(filter: filter, page: 3)

        #expect(mockRepository.moviesCallCount == 1)
        #expect(mockRepository.moviesCalledWith[0].filter?.originalLanguage == "fr")
        #expect(mockRepository.moviesCalledWith[0].page == 3)
    }

    @Test("execute maps genres to movie preview details")
    func executeMapsGenresToMoviePreviewDetails() async throws {
        let moviePreview = MoviePreview.mock(id: 1, genreIDs: [28, 12])
        let genres = Genre.mocks
        let appConfiguration = AppConfiguration.mock()

        mockRepository.moviesStub = .success(page([moviePreview]))
        mockGenreProvider.movieGenresStub = .success(genres)
        mockAppConfigurationProvider.appConfigurationStub = .success(appConfiguration)
        mockLogoImageProvider.imageURLSetStub = .success(nil)

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.movies.count == 1)
        #expect(result.movies[0].genres.count == 2)
        #expect(result.movies[0].genres.contains(where: { $0.name == "Action" }))
        #expect(result.movies[0].genres.contains(where: { $0.name == "Adventure" }))
    }

    @Test("execute fetches logos for each movie")
    func executeFetchesLogosForEachMovie() async throws {
        let moviePreviews = MoviePreview.mocks
        let genres = Genre.mocks
        let appConfiguration = AppConfiguration.mock()

        mockRepository.moviesStub = .success(page(moviePreviews))
        mockGenreProvider.movieGenresStub = .success(genres)
        mockAppConfigurationProvider.appConfigurationStub = .success(appConfiguration)
        mockLogoImageProvider.imageURLSetStub = .success(nil)

        let useCase = makeUseCase()

        _ = try await useCase.execute()

        #expect(mockLogoImageProvider.imageURLSetCallCount == moviePreviews.count)
    }

    @Test("execute with no results returns an empty page")
    func executeWithNoResultsReturnsEmptyPage() async throws {
        let genres = Genre.mocks
        let appConfiguration = AppConfiguration.mock()

        mockRepository.moviesStub = .success(page([]))
        mockGenreProvider.movieGenresStub = .success(genres)
        mockAppConfigurationProvider.appConfigurationStub = .success(appConfiguration)

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.movies.isEmpty)
        #expect(mockLogoImageProvider.imageURLSetCallCount == 0)
    }

    // MARK: - Helpers

    private func page(
        _ movies: [MoviePreview],
        page: Int = 1,
        totalPages: Int = 1
    ) -> MoviePreviewPage {
        MoviePreviewPage(page: page, totalPages: totalPages, movies: movies)
    }

    private func makeUseCase() -> DefaultFetchDiscoverMoviesUseCase {
        DefaultFetchDiscoverMoviesUseCase(
            repository: mockRepository,
            genreProvider: mockGenreProvider,
            appConfigurationProvider: mockAppConfigurationProvider,
            logoImageProvider: mockLogoImageProvider
        )
    }

}
