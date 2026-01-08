//
//  DefaultSearchMediaUseCaseTests.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import CoreDomainTestHelpers
import Foundation
import SearchDomain
import Testing

@testable import SearchApplication

@Suite("DefaultSearchMediaUseCase")
struct DefaultSearchMediaUseCaseTests {

    let mockRepository: MockMediaRepository
    let mockAppConfigurationProvider: MockAppConfigurationProvider

    init() {
        self.mockRepository = MockMediaRepository()
        self.mockAppConfigurationProvider = MockAppConfigurationProvider()
    }

    // MARK: - Success Cases

    @Test("execute returns media preview details on success")
    func executeReturnsMediaPreviewDetailsOnSuccess() async throws {
        let mediaPreviews = MediaPreview.mocks
        let appConfiguration = AppConfiguration.mock()
        mockRepository.searchStub = .success(mediaPreviews)
        mockAppConfigurationProvider.appConfigurationStub = .success(appConfiguration)

        let useCase = makeUseCase()

        let result = try await useCase.execute(query: "test")

        #expect(result.count == mediaPreviews.count)
        #expect(mockRepository.searchCallCount == 1)
        #expect(mockAppConfigurationProvider.appConfigurationCallCount == 1)
    }

    @Test("execute passes correct query and default page to repository")
    func executePassesCorrectQueryAndDefaultPageToRepository() async throws {
        mockRepository.searchStub = .success([])
        mockAppConfigurationProvider.appConfigurationStub = .success(AppConfiguration.mock())

        let useCase = makeUseCase()

        _ = try await useCase.execute(query: "inception")

        #expect(mockRepository.searchCalledWith[0].query == "inception")
        #expect(mockRepository.searchCalledWith[0].page == 1)
    }

    @Test("execute with page passes correct query and page to repository")
    func executeWithPagePassesCorrectQueryAndPageToRepository() async throws {
        mockRepository.searchStub = .success([])
        mockAppConfigurationProvider.appConfigurationStub = .success(AppConfiguration.mock())

        let useCase = makeUseCase()

        _ = try await useCase.execute(query: "inception", page: 5)

        #expect(mockRepository.searchCalledWith[0].query == "inception")
        #expect(mockRepository.searchCalledWith[0].page == 5)
    }

    @Test("execute returns empty array when repository returns empty")
    func executeReturnsEmptyArrayWhenRepositoryReturnsEmpty() async throws {
        mockRepository.searchStub = .success([])
        mockAppConfigurationProvider.appConfigurationStub = .success(AppConfiguration.mock())

        let useCase = makeUseCase()

        let result = try await useCase.execute(query: "nonexistent")

        #expect(result.isEmpty)
    }

    // MARK: - Repository Error Cases

    @Test("execute throws unauthorised error when repository throws unauthorised")
    func executeThrowsUnauthorisedErrorWhenRepositoryThrowsUnauthorised() async throws {
        mockRepository.searchStub = .failure(.unauthorised)
        mockAppConfigurationProvider.appConfigurationStub = .success(AppConfiguration.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(query: "test")
            },
            throws: { error in
                guard let searchError = error as? SearchMediaError else {
                    return false
                }
                if case .unauthorised = searchError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws unknown error when repository throws unknown")
    func executeThrowsUnknownErrorWhenRepositoryThrowsUnknown() async throws {
        let underlyingError = NSError(domain: "test", code: 123)
        mockRepository.searchStub = .failure(.unknown(underlyingError))
        mockAppConfigurationProvider.appConfigurationStub = .success(AppConfiguration.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(query: "test")
            },
            throws: { error in
                guard let searchError = error as? SearchMediaError else {
                    return false
                }
                if case .unknown = searchError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - App Configuration Error Cases

    @Test("execute throws unauthorised error when app config provider throws unauthorised")
    func executeThrowsUnauthorisedErrorWhenAppConfigProviderThrowsUnauthorised() async throws {
        mockRepository.searchStub = .success(MediaPreview.mocks)
        mockAppConfigurationProvider.appConfigurationStub = .failure(.unauthorised)

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(query: "test")
            },
            throws: { error in
                guard let searchError = error as? SearchMediaError else {
                    return false
                }
                if case .unauthorised = searchError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - Helpers

    private func makeUseCase() -> DefaultSearchMediaUseCase {
        DefaultSearchMediaUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigurationProvider
        )
    }

}
