//
//  DefaultFetchTrendingPeopleUseCaseTests.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import CoreDomainTestHelpers
import Foundation
import Testing
@testable import TrendingApplication
import TrendingDomain

@Suite("DefaultFetchTrendingPeopleUseCase")
struct DefaultFetchTrendingPeopleUseCaseTests {

    let mockRepository: MockTrendingRepository
    let mockAppConfigurationProvider: MockAppConfigurationProvider

    init() {
        self.mockRepository = MockTrendingRepository()
        self.mockAppConfigurationProvider = MockAppConfigurationProvider()
    }

    @Test("execute returns person preview details on success")
    func executeReturnsPersonPreviewDetailsOnSuccess() async throws {
        let personPreviews = PersonPreview.mocks
        mockRepository.peopleStub = .success(personPreviews)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.count == personPreviews.count)
        #expect(result[0].id == personPreviews[0].id)
        #expect(result[0].name == personPreviews[0].name)
    }

    @Test("execute calls execute(page:) with page 1")
    func executeCallsExecutePageWithPageOne() async throws {
        mockRepository.peopleStub = .success(PersonPreview.mocks)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        _ = try await useCase.execute()

        #expect(mockRepository.peopleCalledWith == [1])
    }

    @Test("execute with page passes page to repository")
    func executeWithPagePassesPageToRepository() async throws {
        mockRepository.peopleStub = .success(PersonPreview.mocks)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        _ = try await useCase.execute(page: 4)

        #expect(mockRepository.peopleCalledWith == [4])
    }

    @Test("execute calls app configuration provider once")
    func executeCallsAppConfigurationProviderOnce() async throws {
        mockRepository.peopleStub = .success(PersonPreview.mocks)
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        _ = try await useCase.execute()

        #expect(mockAppConfigurationProvider.appConfigurationCallCount == 1)
    }

    @Test("execute with no results returns empty array")
    func executeWithNoResultsReturnsEmptyArray() async throws {
        mockRepository.peopleStub = .success([])
        mockAppConfigurationProvider.appConfigurationStub = .success(.mock())

        let useCase = makeUseCase()

        let result = try await useCase.execute()

        #expect(result.isEmpty)
    }

    // MARK: - Helpers

    private func makeUseCase() -> DefaultFetchTrendingPeopleUseCase {
        DefaultFetchTrendingPeopleUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigurationProvider
        )
    }

}
