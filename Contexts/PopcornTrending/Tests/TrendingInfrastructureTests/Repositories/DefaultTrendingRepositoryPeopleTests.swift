//
//  DefaultTrendingRepositoryPeopleTests.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TrendingDomain
@testable import TrendingInfrastructure

@Suite("DefaultTrendingRepository People")
struct DefaultTrendingRepositoryPeopleTests {

    let mockRemoteDataSource: MockTrendingRemoteDataSource

    init() {
        self.mockRemoteDataSource = MockTrendingRemoteDataSource()
    }

    @Test("people returns values from remote data source")
    func peopleReturnsValuesFromRemoteDataSource() async throws {
        let personPreviews = PersonPreview.mocks
        mockRemoteDataSource.peopleStub = .success(personPreviews)

        let repository = makeRepository()

        let result = try await repository.people(page: 1)

        #expect(result == personPreviews)
    }

    @Test("people passes page to remote data source")
    func peoplePassesPageToRemoteDataSource() async throws {
        mockRemoteDataSource.peopleStub = .success([])

        let repository = makeRepository()

        _ = try await repository.people(page: 4)

        #expect(mockRemoteDataSource.peopleCallCount == 1)
        #expect(mockRemoteDataSource.peopleCalledWith == [4])
    }

    @Test("people returns empty array when remote returns empty")
    func peopleReturnsEmptyArrayWhenRemoteReturnsEmpty() async throws {
        mockRemoteDataSource.peopleStub = .success([])

        let repository = makeRepository()

        let result = try await repository.people(page: 1)

        #expect(result.isEmpty)
    }

    @Test("people throws unauthorised error when remote throws unauthorised")
    func peopleThrowsUnauthorisedErrorWhenRemoteThrowsUnauthorised() async {
        mockRemoteDataSource.peopleStub = .failure(.unauthorised)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.people(page: 1)
            },
            throws: { error in
                guard let repositoryError = error as? TrendingRepositoryError else {
                    return false
                }
                if case .unauthorised = repositoryError {
                    return true
                }
                return false
            }
        )
    }

    @Test("people throws unknown error when remote throws unknown")
    func peopleThrowsUnknownErrorWhenRemoteThrowsUnknown() async {
        let underlyingError = NSError(domain: "test", code: 123)
        mockRemoteDataSource.peopleStub = .failure(.unknown(underlyingError))

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.people(page: 1)
            },
            throws: { error in
                guard let repositoryError = error as? TrendingRepositoryError else {
                    return false
                }
                if case .unknown = repositoryError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - Helpers

    private func makeRepository() -> DefaultTrendingRepository {
        DefaultTrendingRepository(remoteDataSource: mockRemoteDataSource)
    }

}
