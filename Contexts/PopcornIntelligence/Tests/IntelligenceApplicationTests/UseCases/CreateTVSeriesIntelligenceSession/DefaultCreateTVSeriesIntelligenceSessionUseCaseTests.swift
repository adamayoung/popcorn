//
//  DefaultCreateTVSeriesIntelligenceSessionUseCaseTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import IntelligenceApplication
import IntelligenceDomain
import Testing

@Suite("DefaultCreateTVSeriesIntelligenceSessionUseCase")
struct DefaultCreateTVSeriesIntelligenceSessionUseCaseTests {

    let mockRepository: MockTVSeriesLLMSessionRepository

    init() {
        self.mockRepository = MockTVSeriesLLMSessionRepository()
    }

    // MARK: - execute() Tests

    @Test("execute returns session on success")
    func executeReturnsSessionOnSuccess() async throws {
        let mockSession = MockLLMSession()
        mockRepository.sessionStub = .success(mockSession)

        let useCase = makeUseCase()

        let result = try await useCase.execute(tvSeriesID: 123)

        #expect(result is MockLLMSession)
        #expect(mockRepository.sessionCallCount == 1)
    }

    @Test("execute passes correct TV series ID to repository")
    func executePassesCorrectTVSeriesIDToRepository() async throws {
        let mockSession = MockLLMSession()
        mockRepository.sessionStub = .success(mockSession)

        let useCase = makeUseCase()

        _ = try await useCase.execute(tvSeriesID: 789)

        #expect(mockRepository.sessionCalledWith[0] == 789)
    }

    @Test("execute throws session creation failed when repository throws TV series not found")
    func executeThrowsSessionCreationFailedWhenTVSeriesNotFound() async {
        mockRepository.sessionStub = .failure(.tvSeriesNotFound)

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(tvSeriesID: 123)
            },
            throws: { error in
                guard let sessionError = error as? CreateTVSeriesIntelligenceSessionError else {
                    return false
                }
                if case .sessionCreationFailed = sessionError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws session creation failed when repository throws tools not found")
    func executeThrowsSessionCreationFailedWhenToolsNotFound() async {
        mockRepository.sessionStub = .failure(.toolsNotFound)

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(tvSeriesID: 123)
            },
            throws: { error in
                guard let sessionError = error as? CreateTVSeriesIntelligenceSessionError else {
                    return false
                }
                if case .sessionCreationFailed = sessionError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws session creation failed when repository throws unknown error")
    func executeThrowsSessionCreationFailedWhenRepositoryThrowsUnknown() async {
        let underlyingError = NSError(domain: "test", code: 123)
        mockRepository.sessionStub = .failure(.unknown(underlyingError))

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(tvSeriesID: 123)
            },
            throws: { error in
                guard let sessionError = error as? CreateTVSeriesIntelligenceSessionError else {
                    return false
                }
                if case .sessionCreationFailed = sessionError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - Helpers

    private func makeUseCase() -> DefaultCreateTVSeriesIntelligenceSessionUseCase {
        DefaultCreateTVSeriesIntelligenceSessionUseCase(
            tvSeriesSessionRepository: mockRepository
        )
    }

}
