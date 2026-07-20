//
//  DefaultFetchMovieRecommendationsUseCaseTests.swift
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

@Suite("DefaultFetchMovieRecommendationsUseCase Tests")
struct DefaultFetchMovieRecommendationsUseCaseTests {

    let mockRecommendationRepository: MockMovieRecommendationRepository
    let mockImageRepository: MockMovieImageRepository
    let mockAppConfigProvider: MockAppConfigurationProvider

    init() {
        self.mockRecommendationRepository = MockMovieRecommendationRepository()
        self.mockImageRepository = MockMovieImageRepository()
        self.mockAppConfigProvider = MockAppConfigurationProvider()
        mockAppConfigProvider.appConfigurationStub = .success(.mock())
    }

    // MARK: - Limit

    @Test("execute with a limit returns at most `limit` items in repository order")
    func executeWithLimitCapsCountInOrder() async throws {
        mockRecommendationRepository.recommendationsStub = .success([
            Self.preview(id: 3),
            Self.preview(id: 1),
            Self.preview(id: 2)
        ])

        let useCase = makeUseCase()

        let result = try await useCase.execute(movieID: 100, page: 1, limit: 2)

        #expect(result.map(\.id) == [3, 1])
    }

    @Test("execute applies the limit before the image-collection and theme-colour fan-out")
    func executeAppliesLimitBeforeFanOut() async throws {
        let previews = (1 ... 20).map { Self.preview(id: $0) }
        mockRecommendationRepository.recommendationsStub = .success(previews)
        for preview in previews {
            mockImageRepository.imageCollectionStubs[preview.id] = .success(.mock(id: preview.id))
        }
        let themeColorProvider = SpyThemeColorProvider(themeColorResult: .mock())

        let useCase = makeUseCase(themeColorProvider: themeColorProvider)

        _ = try await useCase.execute(movieID: 100, page: 1, limit: 5)

        #expect(mockImageRepository.imageCollectionCallCount == 5)
        #expect(Set(mockImageRepository.imageCollectionCalledWith).isSubset(of: Set(1 ... 5)))
        #expect(themeColorProvider.callCount == 5)
    }

    // MARK: - Fault tolerance

    @Test("execute keeps a movie whose image collection fails, without its logo")
    func executeToleratesPerItemImageFailure() async throws {
        mockRecommendationRepository.recommendationsStub = .success([
            Self.preview(id: 1),
            Self.preview(id: 2)
        ])
        // Only movie 1 has an image collection; movie 2 throws `.notFound`.
        mockImageRepository.imageCollectionStubs[1] = .success(.mock(id: 1))

        let useCase = makeUseCase()

        let result = try await useCase.execute(movieID: 100, page: 1, limit: nil)

        #expect(result.count == 2)
        let movie1 = try #require(result.first { $0.id == 1 })
        let movie2 = try #require(result.first { $0.id == 2 })
        #expect(movie1.logoURLSet != nil)
        #expect(movie2.logoURLSet == nil)
    }

    @Test("execute extracts theme colours concurrently")
    func executeExtractsThemeColoursConcurrently() async throws {
        mockRecommendationRepository.recommendationsStub = .success([
            Self.preview(id: 1),
            Self.preview(id: 2)
        ])
        mockImageRepository.imageCollectionStubs[1] = .success(.mock(id: 1))
        mockImageRepository.imageCollectionStubs[2] = .success(.mock(id: 2))
        let themeColorProvider = RendezvousThemeColorProvider(expectedConcurrent: 2)

        let useCase = makeUseCase(themeColorProvider: themeColorProvider)

        _ = try await useCase.execute(movieID: 100, page: 1, limit: nil)

        #expect(themeColorProvider.didReachRendezvous)
        #expect(!themeColorProvider.didTimeOut)
    }

    // MARK: - Backwards compatibility

    @Test("execute(movieID:) fetches page 1 with no limit")
    func executeForwardsToPageOneWithoutLimit() async throws {
        let previews = (1 ... 8).map { Self.preview(id: $0) }
        mockRecommendationRepository.recommendationsStub = .success(previews)

        let useCase = makeUseCase()

        let result = try await useCase.execute(movieID: 100)

        #expect(result.count == 8)
        #expect(mockRecommendationRepository.recommendationsCalledWith.count == 1)
        #expect(mockRecommendationRepository.recommendationsCalledWith.first?.movieID == 100)
        #expect(mockRecommendationRepository.recommendationsCalledWith.first?.page == 1)
    }

    // MARK: - Errors

    @Test("execute throws FetchMovieRecommendationsError on repository failure")
    func executeThrowsOnRepositoryFailure() async {
        mockRecommendationRepository.recommendationsStub = .failure(.notFound)

        let useCase = makeUseCase()

        await #expect(
            performing: { try await useCase.execute(movieID: 100, page: 1, limit: 5) },
            throws: { $0 is FetchMovieRecommendationsError }
        )
    }

    @Test("execute succeeds without a theme-colour provider and applies no colours")
    func executeSucceedsWithoutThemeColorProvider() async throws {
        mockRecommendationRepository.recommendationsStub = .success([
            Self.preview(id: 1),
            Self.preview(id: 2)
        ])
        mockImageRepository.imageCollectionStubs[1] = .success(.mock(id: 1))
        mockImageRepository.imageCollectionStubs[2] = .success(.mock(id: 2))

        let useCase = makeUseCase(themeColorProvider: nil)

        let result = try await useCase.execute(movieID: 100, page: 1, limit: nil)

        #expect(result.count == 2)
        #expect(result.allSatisfy { $0.themeColor == nil })
    }

    // MARK: - Protocol default

    @Test("the protocol default trims the full result post-hoc")
    func protocolDefaultTrimsResult() async throws {
        let conformer = PageOnlyRecommendationsUseCase(count: 10)

        let result = try await conformer.execute(movieID: 1, page: 1, limit: 3)

        #expect(result.count == 3)
    }

}

// MARK: - Factory

extension DefaultFetchMovieRecommendationsUseCaseTests {

    func makeUseCase(
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) -> DefaultFetchMovieRecommendationsUseCase {
        DefaultFetchMovieRecommendationsUseCase(
            movieRecommendationRepository: mockRecommendationRepository,
            movieImageRepository: mockImageRepository,
            appConfigurationProvider: mockAppConfigProvider,
            themeColorProvider: themeColorProvider
        )
    }

    static func preview(id: Int) -> MoviePreview {
        MoviePreview(
            id: id,
            title: "Movie \(id)",
            overview: "Overview \(id)",
            posterPath: URL(string: "/poster\(id).jpg")
        )
    }

}

// MARK: - Test Doubles

/// A concurrency-safe theme-colour spy. Its call tracking is guarded by a `Mutex`
/// because the use case fans colour extraction out across a task group.
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

/// A theme-colour provider that blocks each call until `expectedConcurrent` of them
/// are simultaneously in flight, then releases all. A serial caller never reaches the
/// threshold, so a fallback timeout releases the waiters and records `didTimeOut` —
/// letting the test assert concurrency deterministically in the passing direction.
private final class RendezvousThemeColorProvider: ThemeColorProviding, @unchecked Sendable {

    private struct State {
        var arrived = 0
        var waiters: [CheckedContinuation<Void, Never>] = []
        var reachedRendezvous = false
        var timedOut = false
    }

    private let expectedConcurrent: Int
    private let state = Mutex(State())

    var didReachRendezvous: Bool {
        state.withLock { $0.reachedRendezvous }
    }

    var didTimeOut: Bool {
        state.withLock { $0.timedOut }
    }

    init(expectedConcurrent: Int) {
        self.expectedConcurrent = expectedConcurrent
    }

    func themeColor(for posterThumbnailURL: URL) async -> ThemeColor? {
        await withCheckedContinuation { continuation in
            let toResume: [CheckedContinuation<Void, Never>] = state.withLock { state in
                state.arrived += 1
                state.waiters.append(continuation)
                guard state.arrived >= expectedConcurrent else {
                    return []
                }
                state.reachedRendezvous = true
                let waiters = state.waiters
                state.waiters = []
                return waiters
            }
            for waiter in toResume {
                waiter.resume()
            }
            if toResume.isEmpty {
                scheduleTimeout()
            }
        }
        return nil
    }

    /// Releases any stranded waiter after a generous delay so a serial implementation
    /// fails via `didTimeOut` instead of hanging the suite.
    private func scheduleTimeout() {
        Task {
            try? await Task.sleep(for: .seconds(5))
            let toResume: [CheckedContinuation<Void, Never>] = state.withLock { state in
                guard !state.waiters.isEmpty else {
                    return []
                }
                state.timedOut = true
                let waiters = state.waiters
                state.waiters = []
                return waiters
            }
            for waiter in toResume {
                waiter.resume()
            }
        }
    }

}

/// A minimal conformer that implements only the two original protocol requirements,
/// exercising the `execute(movieID:page:limit:)` protocol-extension default.
private struct PageOnlyRecommendationsUseCase: FetchMovieRecommendationsUseCase {

    let count: Int

    func execute(
        movieID: Int
    ) async throws(FetchMovieRecommendationsError) -> [MoviePreviewDetails] {
        try await execute(movieID: movieID, page: 1)
    }

    func execute(
        movieID: Int,
        page: Int
    ) async throws(FetchMovieRecommendationsError) -> [MoviePreviewDetails] {
        (1 ... count).map { MoviePreviewDetails(id: $0, title: "Movie \($0)", overview: "") }
    }

}
