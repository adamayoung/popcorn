//
//  DefaultFetchAppConfigurationUseCaseTests.swift
//  PopcornConfiguration
//
//  Copyright © 2025 Adam Young.
//

@testable import ConfigurationApplication
import ConfigurationDomain
import CoreDomain
import CoreDomainTestHelpers
import Foundation
import ObservabilityTestHelpers
import Testing

@Suite("DefaultFetchAppConfigurationUseCase")
struct DefaultFetchAppConfigurationUseCaseTests {

    let mockRepository: MockConfigurationRepository
    let mockObservabilityProvider: MockObservabilityProvider

    init() {
        self.mockRepository = MockConfigurationRepository()
        self.mockObservabilityProvider = MockObservabilityProvider()
    }

    @Test("execute returns app configuration on success")
    func executeReturnsAppConfigurationOnSuccess() async throws {
        let expectedConfiguration = AppConfiguration.mock()
        mockRepository.configurationStub = .success(expectedConfiguration)

        let useCase = DefaultFetchAppConfigurationUseCase(repository: mockRepository)

        _ = try await useCase.execute()

        #expect(mockRepository.configurationCallCount == 1)
    }

    @Test("execute creates span with correct operation")
    func executeCreatesSpanWithCorrectOperation() async throws {
        let expectedConfiguration = AppConfiguration.mock()
        let mockSpan = MockSpan()

        mockRepository.configurationStub = .success(expectedConfiguration)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = DefaultFetchAppConfigurationUseCase(repository: mockRepository)

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await useCase.execute()
        }

        #expect(mockSpan.startChildCallCount == 1)
        #expect(mockSpan.startChildCalledWith[0].operation.value == SpanOperation.useCaseExecute.value)
        #expect(mockSpan.startChildCalledWith[0].description == "FetchAppConfigurationUseCase.execute")
    }

    @Test("execute finishes span on success")
    func executeFinishesSpanOnSuccess() async throws {
        let expectedConfiguration = AppConfiguration.mock()
        let mockSpan = MockSpan()

        mockRepository.configurationStub = .success(expectedConfiguration)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = DefaultFetchAppConfigurationUseCase(repository: mockRepository)

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await useCase.execute()
        }

        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .ok)
    }

    @Test("execute throws unauthorised error when repository throws unauthorised")
    func executeThrowsUnauthorisedErrorWhenRepositoryThrowsUnauthorised() async {
        mockRepository.configurationStub = .failure(.unauthorised)

        let useCase = DefaultFetchAppConfigurationUseCase(repository: mockRepository)

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchAppConfigurationError else {
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
        mockRepository.configurationStub = .failure(.unknown(underlyingError))

        let useCase = DefaultFetchAppConfigurationUseCase(repository: mockRepository)

        await #expect(
            performing: {
                try await useCase.execute()
            },
            throws: { error in
                guard let fetchError = error as? FetchAppConfigurationError else {
                    return false
                }
                if case .unknown = fetchError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute sets error on span and finishes with internal error on failure")
    func executeSetsErrorOnSpanAndFinishesWithInternalErrorOnFailure() async {
        let mockSpan = MockSpan()

        mockRepository.configurationStub = .failure(.unauthorised)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let useCase = DefaultFetchAppConfigurationUseCase(repository: mockRepository)

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
        let expectedConfiguration = AppConfiguration.mock()
        mockRepository.configurationStub = .success(expectedConfiguration)

        SpanContext.provider = nil

        let useCase = DefaultFetchAppConfigurationUseCase(repository: mockRepository)

        _ = try await useCase.execute()

        #expect(mockRepository.configurationCallCount == 1)
    }

}
