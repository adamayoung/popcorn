//
//  DefaultFetchPopularMoviesUseCaseTests.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import CoreDomainTestHelpers
import Foundation
@testable import MoviesApplication
import MoviesDomain
import Synchronization
import Testing

@Suite("DefaultFetchPopularMoviesUseCase Tests")
struct DefaultFetchPopularMoviesUseCaseTests {

    let mockPopularRepository: MockPopularMovieRepository
    let mockImageRepository: MockMovieImageRepository
    let mockAppConfigProvider: MockAppConfigurationProvider

    init() {
        self.mockPopularRepository = MockPopularMovieRepository()
        self.mockImageRepository = MockMovieImageRepository()
        self.mockAppConfigProvider = MockAppConfigurationProvider()
        mockAppConfigProvider.appConfigurationStub = .success(.mock())
    }

    @Test("execute returns the first page of movie preview details on success")
    func executeReturnsMoviePreviewDetailsOnSuccess() async throws {
        let previews = [Self.preview(id: 1), Self.preview(id: 2)]
        stubImageCollections(for: previews)
        mockPopularRepository.popularStub = .success(Self.page(previews))

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.movies.count == previews.count)
        #expect(Set(result.movies.map(\.id)) == Set([1, 2]))
    }

    @Test("execute fetches page 1")
    func executeFetchesPageOne() async throws {
        mockPopularRepository.popularStub = .success(Self.page([]))

        let useCase = makeUseCase()

        _ = try await useCase.execute()

        #expect(mockPopularRepository.popularCalledWith == [1])
    }

    @Test("execute(page:) passes the page to the repository")
    func executePassesPageToRepository() async throws {
        mockPopularRepository.popularStub = .success(Self.page([]))

        let useCase = makeUseCase()

        _ = try await useCase.execute(page: 5)

        #expect(mockPopularRepository.popularCalledWith == [5])
    }

    @Test("execute(page:) surfaces page and totalPages from the repository")
    func executeSurfacesPageAndTotalPages() async throws {
        let previews = [Self.preview(id: 1)]
        stubImageCollections(for: previews)
        mockPopularRepository.popularStub = .success(Self.page(previews, page: 3, totalPages: 7))

        let useCase = makeUseCase()

        let result = try await useCase.execute(page: 3)

        #expect(result.page == 3)
        #expect(result.totalPages == 7)
    }

    @Test("execute maps movies with their image collections")
    func executeMapsMoviesWithImageCollections() async throws {
        let previews = [Self.preview(id: 1), Self.preview(id: 2)]
        stubImageCollections(for: previews)
        mockPopularRepository.popularStub = .success(Self.page(previews))

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(mockImageRepository.imageCollectionCallCount == 2)
        #expect(result.movies.allSatisfy { $0.logoURLSet != nil })
    }

    @Test("execute with no results returns empty movies but keeps pagination metadata")
    func executeWithNoResultsKeepsMetadata() async throws {
        mockPopularRepository.popularStub = .success(Self.page([], page: 4, totalPages: 9))

        let useCase = makeUseCase()

        let result = try await useCase.execute(page: 4)

        #expect(result.movies.isEmpty)
        #expect(result.page == 4)
        #expect(result.totalPages == 9)
    }

    @Test("execute throws FetchPopularMoviesError on repository failure")
    func executeThrowsOnRepositoryFailure() async {
        mockPopularRepository.popularStub = .failure(.notFound)

        let useCase = makeUseCase()

        await #expect(
            performing: { try await useCase.execute() },
            throws: { $0 is FetchPopularMoviesError }
        )
    }

    @Test("execute succeeds without a theme-colour provider and applies no colours")
    func executeSucceedsWithoutThemeColorProvider() async throws {
        let previews = [Self.preview(id: 1), Self.preview(id: 2)]
        stubImageCollections(for: previews)
        mockPopularRepository.popularStub = .success(Self.page(previews))

        let useCase = makeUseCase(themeColorProvider: nil)

        let result = try await useCase.execute()

        #expect(result.movies.count == 2)
        #expect(result.movies.allSatisfy { $0.themeColor == nil })
    }

    @Test("execute extracts a theme colour when the provider and a poster path are present")
    func executeExtractsThemeColorWhenPosterPresent() async throws {
        let preview = Self.preview(id: 1)
        stubImageCollections(for: [preview])
        mockPopularRepository.popularStub = .success(Self.page([preview]))
        let themeColorProvider = SpyThemeColorProvider(themeColorResult: .mock())

        let useCase = makeUseCase(themeColorProvider: themeColorProvider)

        let result = try await useCase.execute()

        #expect(result.movies[0].themeColor != nil)
        #expect(themeColorProvider.callCount == 1)
    }

}

// MARK: - Factory & fixtures

extension DefaultFetchPopularMoviesUseCaseTests {

    func makeUseCase(
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) -> DefaultFetchPopularMoviesUseCase {
        DefaultFetchPopularMoviesUseCase(
            popularMovieRepository: mockPopularRepository,
            movieImageRepository: mockImageRepository,
            appConfigurationProvider: mockAppConfigProvider,
            themeColorProvider: themeColorProvider
        )
    }

    func stubImageCollections(for previews: [MoviePreview]) {
        for preview in previews {
            mockImageRepository.imageCollectionStubs[preview.id] = .success(.mock(id: preview.id))
        }
    }

    static func preview(id: Int) -> MoviePreview {
        MoviePreview(
            id: id,
            title: "Movie \(id)",
            overview: "Overview \(id)",
            posterPath: URL(string: "/poster\(id).jpg")
        )
    }

    static func page(
        _ movies: [MoviePreview],
        page: Int = 1,
        totalPages: Int = 1
    ) -> MoviePreviewPage {
        MoviePreviewPage(page: page, totalPages: totalPages, movies: movies)
    }

}

// MARK: - Test doubles

/// A concurrency-safe theme-colour spy. Its call tracking is guarded by a `Mutex`
/// because the use case fans colour extraction out across the movies.
private final class SpyThemeColorProvider: ThemeColorProviding, @unchecked Sendable {

    private let result: ThemeColor?
    private let count = Mutex(0)

    var callCount: Int {
        count.withLock { $0 }
    }

    init(themeColorResult: ThemeColor?) {
        self.result = themeColorResult
    }

    func themeColor(for posterThumbnailURL: URL) async -> ThemeColor? {
        count.withLock { $0 += 1 }
        return result
    }

}
