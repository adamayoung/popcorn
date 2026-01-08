//
//  DefaultAddMediaSearchHistoryEntryUseCaseTests.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SearchDomain
import Testing

@testable import SearchApplication

@Suite("DefaultAddMediaSearchHistoryEntryUseCase")
struct DefaultAddMediaSearchHistoryEntryUseCaseTests {

    let mockRepository: MockMediaRepository

    init() {
        self.mockRepository = MockMediaRepository()
    }

    // MARK: - Movie Entry Tests

    @Test("execute movieID saves movie search history entry")
    func executeMovieIDSavesMovieSearchHistoryEntry() async throws {
        mockRepository.saveMovieSearchHistoryEntryStub = .success(())

        let useCase = makeUseCase()

        try await useCase.execute(movieID: 123)

        #expect(mockRepository.saveMovieSearchHistoryEntryCallCount == 1)
        #expect(mockRepository.saveMovieSearchHistoryEntryCalledWith[0].id == 123)
    }

    @Test("execute movieID throws unknown error when repository fails")
    func executeMovieIDThrowsUnknownErrorWhenRepositoryFails() async throws {
        let underlyingError = NSError(domain: "test", code: 123)
        mockRepository.saveMovieSearchHistoryEntryStub = .failure(.unknown(underlyingError))

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(movieID: 123)
            },
            throws: { error in
                guard let addError = error as? AddMediaSearchHistoryEntryError else {
                    return false
                }
                if case .unknown = addError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - TV Series Entry Tests

    @Test("execute tvSeriesID saves TV series search history entry")
    func executeTVSeriesIDSavesTVSeriesSearchHistoryEntry() async throws {
        mockRepository.saveTVSeriesSearchHistoryEntryStub = .success(())

        let useCase = makeUseCase()

        try await useCase.execute(tvSeriesID: 456)

        #expect(mockRepository.saveTVSeriesSearchHistoryEntryCallCount == 1)
        #expect(mockRepository.saveTVSeriesSearchHistoryEntryCalledWith[0].id == 456)
    }

    @Test("execute tvSeriesID throws unknown error when repository fails")
    func executeTVSeriesIDThrowsUnknownErrorWhenRepositoryFails() async throws {
        let underlyingError = NSError(domain: "test", code: 456)
        mockRepository.saveTVSeriesSearchHistoryEntryStub = .failure(.unknown(underlyingError))

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(tvSeriesID: 456)
            },
            throws: { error in
                guard let addError = error as? AddMediaSearchHistoryEntryError else {
                    return false
                }
                if case .unknown = addError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - Person Entry Tests

    @Test("execute personID saves person search history entry")
    func executePersonIDSavesPersonSearchHistoryEntry() async throws {
        mockRepository.savePersonSearchHistoryEntryStub = .success(())

        let useCase = makeUseCase()

        try await useCase.execute(personID: 789)

        #expect(mockRepository.savePersonSearchHistoryEntryCallCount == 1)
        #expect(mockRepository.savePersonSearchHistoryEntryCalledWith[0].id == 789)
    }

    @Test("execute personID throws unknown error when repository fails")
    func executePersonIDThrowsUnknownErrorWhenRepositoryFails() async throws {
        let underlyingError = NSError(domain: "test", code: 789)
        mockRepository.savePersonSearchHistoryEntryStub = .failure(.unknown(underlyingError))

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(personID: 789)
            },
            throws: { error in
                guard let addError = error as? AddMediaSearchHistoryEntryError else {
                    return false
                }
                if case .unknown = addError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - Helpers

    private func makeUseCase() -> DefaultAddMediaSearchHistoryEntryUseCase {
        DefaultAddMediaSearchHistoryEntryUseCase(repository: mockRepository)
    }

}
