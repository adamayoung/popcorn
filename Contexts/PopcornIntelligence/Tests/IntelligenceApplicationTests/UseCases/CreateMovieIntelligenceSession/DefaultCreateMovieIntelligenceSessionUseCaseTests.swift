//
//  DefaultCreateMovieIntelligenceSessionUseCaseTests.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
@testable import IntelligenceApplication
import IntelligenceDomain
import Testing

@Suite("DefaultCreateMovieIntelligenceSessionUseCase")
struct DefaultCreateMovieIntelligenceSessionUseCaseTests {

    let mockRepository: MockMovieLLMSessionRepository

    init() {
        self.mockRepository = MockMovieLLMSessionRepository()
    }

    // MARK: - execute() Tests

    @Test("execute returns session on success")
    func executeReturnsSessionOnSuccess() async throws {
        let mockSession = MockLLMSession()
        mockRepository.sessionStub = .success(mockSession)

        let useCase = makeUseCase()

        let result = try await useCase.execute(movieID: 123)

        #expect(result is MockLLMSession)
        #expect(mockRepository.sessionCallCount == 1)
    }

    @Test("execute passes correct movie ID to repository")
    func executePassesCorrectMovieIDToRepository() async throws {
        let mockSession = MockLLMSession()
        mockRepository.sessionStub = .success(mockSession)

        let useCase = makeUseCase()

        _ = try await useCase.execute(movieID: 456)

        #expect(mockRepository.sessionCalledWith[0] == 456)
    }

    @Test("execute throws session creation failed when repository throws movie not found")
    func executeThrowsSessionCreationFailedWhenMovieNotFound() async {
        mockRepository.sessionStub = .failure(.movieNotFound)

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(movieID: 123)
            },
            throws: { error in
                guard let sessionError = error as? CreateMovieIntelligenceSessionError else {
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
                try await useCase.execute(movieID: 123)
            },
            throws: { error in
                guard let sessionError = error as? CreateMovieIntelligenceSessionError else {
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
                try await useCase.execute(movieID: 123)
            },
            throws: { error in
                guard let sessionError = error as? CreateMovieIntelligenceSessionError else {
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

    private func makeUseCase() -> DefaultCreateMovieIntelligenceSessionUseCase {
        DefaultCreateMovieIntelligenceSessionUseCase(
            movieSessionRepository: mockRepository
        )
    }

}
