//
//  DefaultFetchDiscoverMoviesUseCaseObservabilityTests.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import CoreDomainTestHelpers
import DiscoverDomain
import Foundation
import ObservabilityTestHelpers
import Testing

@testable import DiscoverApplication

@Suite("DefaultFetchDiscoverMoviesUseCase Observability")
struct DefaultFetchDiscoverMoviesUseCaseObservabilityTests {

    let mockRepository: MockDiscoverMovieRepository
    let mockGenreProvider: MockGenreProvider
    let mockAppConfigurationProvider: MockAppConfigurationProvider
    let mockLogoImageProvider: MockMovieLogoImageProvider
    let mockObservabilityProvider: MockObservabilityProvider

    init() {
        self.mockRepository = MockDiscoverMovieRepository()
        self.mockGenreProvider = MockGenreProvider()
        self.mockAppConfigurationProvider = MockAppConfigurationProvider()
        self.mockLogoImageProvider = MockMovieLogoImageProvider()
        self.mockObservabilityProvider = MockObservabilityProvider()
    }

    @Test("execute creates span with correct operation")
    func executeCreatesSpanWithCorrectOperation() async throws {
        let mockSpan = MockSpan()
        mockRepository.moviesStub = .success(MoviePreview.mocks)
        mockGenreProvider.movieGenresStub = .success(Genre.mocks)
        mockAppConfigurationProvider.appConfigurationStub = .success(AppConfiguration.mock())
        mockLogoImageProvider.imageURLSetStub = .success(nil)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = makeUseCase()

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await useCase.execute()
        }

        #expect(mockSpan.startChildCallCount == 1)
        #expect(mockSpan.startChildCalledWith[0].operation.value == SpanOperation.useCaseExecute.value)
        #expect(mockSpan.startChildCalledWith[0].description == "FetchDiscoverMoviesUseCase.execute")
    }

    @Test("execute finishes span on success")
    func executeFinishesSpanOnSuccess() async throws {
        let mockSpan = MockSpan()
        mockRepository.moviesStub = .success(MoviePreview.mocks)
        mockGenreProvider.movieGenresStub = .success(Genre.mocks)
        mockAppConfigurationProvider.appConfigurationStub = .success(AppConfiguration.mock())
        mockLogoImageProvider.imageURLSetStub = .success(nil)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = makeUseCase()

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await useCase.execute()
        }

        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .ok)
    }

    @Test("execute sets error on span and finishes with internal error on failure")
    func executeSetsErrorOnSpanAndFinishesWithInternalErrorOnFailure() async throws {
        let mockSpan = MockSpan()
        mockRepository.moviesStub = .failure(.unauthorised)
        mockGenreProvider.movieGenresStub = .success(Genre.mocks)
        mockAppConfigurationProvider.appConfigurationStub = .success(AppConfiguration.mock())
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
                    try await useCase.execute()
                }
            },
            throws: { _ in true }
        )

        #expect(mockSpan.setDataCallCount >= 1)
        let errorEntry = mockSpan.setDataCalledWith.first(where: { $0.key == "error" })
        #expect(errorEntry != nil)
        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .internalError)
    }

    @Test("execute succeeds without span")
    func executeSucceedsWithoutSpan() async throws {
        mockRepository.moviesStub = .success(MoviePreview.mocks)
        mockGenreProvider.movieGenresStub = .success(Genre.mocks)
        mockAppConfigurationProvider.appConfigurationStub = .success(AppConfiguration.mock())
        mockLogoImageProvider.imageURLSetStub = .success(nil)

        SpanContext.provider = nil

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.count == MoviePreview.mocks.count)
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
