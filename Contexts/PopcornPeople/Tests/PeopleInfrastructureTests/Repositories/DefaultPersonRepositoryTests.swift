//
//  DefaultPersonRepositoryTests.swift
//  PopcornPeople
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PeopleDomain
@testable import PeopleInfrastructure
import Testing

@Suite("DefaultPersonRepository")
struct DefaultPersonRepositoryTests {

    let mockRemoteDataSource: MockPersonRemoteDataSource
    let mockLocalDataSource: MockPersonLocalDataSource

    init() {
        self.mockRemoteDataSource = MockPersonRemoteDataSource()
        self.mockLocalDataSource = MockPersonLocalDataSource()
    }

    // MARK: - Cache Hit Tests

    @Test("person returns cached value when available")
    func personReturnsCachedValueWhenAvailable() async throws {
        let cachedPerson = Person.mock(id: 1, name: "Tom Hanks")
        mockLocalDataSource.personStub = cachedPerson

        let repository = makeRepository()

        let result = try await repository.person(withID: 1)

        #expect(result == cachedPerson)
        let localCallCount = await mockLocalDataSource.personCallCount
        #expect(localCallCount == 1)
        #expect(mockRemoteDataSource.personCallCount == 0)
    }

    // MARK: - Cache Miss Tests

    @Test("person fetches from remote when cache is empty")
    func personFetchesFromRemoteWhenCacheIsEmpty() async throws {
        let remotePerson = Person.mock(id: 1, name: "Tom Hanks")
        mockLocalDataSource.personStub = nil
        mockRemoteDataSource.personStub = .success(remotePerson)

        let repository = makeRepository()

        let result = try await repository.person(withID: 1)

        #expect(result == remotePerson)
        let localCallCount = await mockLocalDataSource.personCallCount
        #expect(localCallCount == 1)
        #expect(mockRemoteDataSource.personCallCount == 1)
    }

    @Test("person caches remote value after fetching")
    func personCachesRemoteValueAfterFetching() async throws {
        let remotePerson = Person.mock(id: 1, name: "Tom Hanks")
        mockLocalDataSource.personStub = nil
        mockRemoteDataSource.personStub = .success(remotePerson)

        let repository = makeRepository()

        _ = try await repository.person(withID: 1)

        let setCallCount = await mockLocalDataSource.setPersonCallCount
        #expect(setCallCount == 1)
        let calledWith = await mockLocalDataSource.setPersonCalledWith
        #expect(calledWith[0] == remotePerson)
    }

    @Test("person passes correct ID to data sources")
    func personPassesCorrectIDToDataSources() async throws {
        let remotePerson = Person.mock(id: 42)
        mockLocalDataSource.personStub = nil
        mockRemoteDataSource.personStub = .success(remotePerson)

        let repository = makeRepository()

        _ = try await repository.person(withID: 42)

        let localCalledWith = await mockLocalDataSource.personCalledWith
        #expect(localCalledWith[0] == 42)
        #expect(mockRemoteDataSource.personCalledWith[0] == 42)
    }

    // MARK: - Error Tests

    @Test("person throws notFound error when remote throws notFound")
    func personThrowsNotFoundWhenRemoteThrowsNotFound() async {
        mockLocalDataSource.personStub = nil
        mockRemoteDataSource.personStub = .failure(.notFound)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.person(withID: 999)
            },
            throws: { error in
                guard let repoError = error as? PersonRepositoryError else {
                    return false
                }
                if case .notFound = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("person throws unauthorised error when remote throws unauthorised")
    func personThrowsUnauthorisedWhenRemoteThrowsUnauthorised() async {
        mockLocalDataSource.personStub = nil
        mockRemoteDataSource.personStub = .failure(.unauthorised)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.person(withID: 1)
            },
            throws: { error in
                guard let repoError = error as? PersonRepositoryError else {
                    return false
                }
                if case .unauthorised = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("person throws unknown error when remote throws unknown")
    func personThrowsUnknownWhenRemoteThrowsUnknown() async {
        let underlyingError = NSError(domain: "test", code: 456)
        mockLocalDataSource.personStub = nil
        mockRemoteDataSource.personStub = .failure(.unknown(underlyingError))

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.person(withID: 1)
            },
            throws: { error in
                guard let repoError = error as? PersonRepositoryError else {
                    return false
                }
                if case .unknown = repoError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - Helpers

    private func makeRepository() -> DefaultPersonRepository {
        DefaultPersonRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )
    }

}
