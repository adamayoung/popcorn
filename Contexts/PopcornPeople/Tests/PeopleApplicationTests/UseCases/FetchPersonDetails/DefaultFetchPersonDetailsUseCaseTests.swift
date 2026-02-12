//
//  DefaultFetchPersonDetailsUseCaseTests.swift
//  PopcornPeople
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import CoreDomainTestHelpers
import Foundation
@testable import PeopleApplication
import PeopleDomain
import Testing

@Suite("DefaultFetchPersonDetailsUseCase")
struct DefaultFetchPersonDetailsUseCaseTests {

    let mockRepository: MockPersonRepository
    let mockAppConfigurationProvider: MockAppConfigurationProvider

    init() {
        self.mockRepository = MockPersonRepository()
        self.mockAppConfigurationProvider = MockAppConfigurationProvider()
    }

    // MARK: - Success Cases

    @Test("execute returns person details on success")
    func executeReturnsPersonDetailsOnSuccess() async throws {
        let person = Person.mock(id: 1, name: "Tom Hanks")
        let appConfiguration = AppConfiguration.mock()
        mockRepository.personStub = .success(person)
        mockAppConfigurationProvider.appConfigurationStub = .success(appConfiguration)

        let useCase = makeUseCase()

        let result = try await useCase.execute(id: 1)

        #expect(result.id == person.id)
        #expect(result.name == person.name)
        #expect(mockRepository.personCallCount == 1)
        #expect(mockAppConfigurationProvider.appConfigurationCallCount == 1)
    }

    @Test("execute passes correct ID to repository")
    func executePassesCorrectIDToRepository() async throws {
        let person = Person.mock(id: 42)
        let appConfiguration = AppConfiguration.mock()
        mockRepository.personStub = .success(person)
        mockAppConfigurationProvider.appConfigurationStub = .success(appConfiguration)

        let useCase = makeUseCase()

        _ = try await useCase.execute(id: 42)

        #expect(mockRepository.personCalledWith[0] == 42)
    }

    // MARK: - Repository Error Cases

    @Test("execute throws notFound error when repository throws notFound")
    func executeThrowsNotFoundErrorWhenRepositoryThrowsNotFound() async {
        mockRepository.personStub = .failure(.notFound)
        mockAppConfigurationProvider.appConfigurationStub = .success(AppConfiguration.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(id: 999)
            },
            throws: { error in
                guard let fetchError = error as? FetchPersonDetailsError else {
                    return false
                }
                if case .notFound = fetchError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws unauthorised error when repository throws unauthorised")
    func executeThrowsUnauthorisedErrorWhenRepositoryThrowsUnauthorised() async {
        mockRepository.personStub = .failure(.unauthorised)
        mockAppConfigurationProvider.appConfigurationStub = .success(AppConfiguration.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(id: 1)
            },
            throws: { error in
                guard let fetchError = error as? FetchPersonDetailsError else {
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
        mockRepository.personStub = .failure(.unknown(underlyingError))
        mockAppConfigurationProvider.appConfigurationStub = .success(AppConfiguration.mock())

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(id: 1)
            },
            throws: { error in
                guard let fetchError = error as? FetchPersonDetailsError else {
                    return false
                }
                if case .unknown = fetchError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - App Configuration Error Cases

    @Test("execute throws unauthorised error when app config provider throws unauthorised")
    func executeThrowsUnauthorisedErrorWhenAppConfigProviderThrowsUnauthorised() async {
        mockRepository.personStub = .success(Person.mock())
        mockAppConfigurationProvider.appConfigurationStub = .failure(.unauthorised)

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(id: 1)
            },
            throws: { error in
                guard let fetchError = error as? FetchPersonDetailsError else {
                    return false
                }
                if case .unauthorised = fetchError {
                    return true
                }
                return false
            }
        )
    }

    @Test("execute throws unknown error when app config provider throws unknown")
    func executeThrowsUnknownErrorWhenAppConfigProviderThrowsUnknown() async {
        let underlyingError = NSError(domain: "test", code: 456)
        mockRepository.personStub = .success(Person.mock())
        mockAppConfigurationProvider.appConfigurationStub = .failure(.unknown(underlyingError))

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(id: 1)
            },
            throws: { error in
                guard let fetchError = error as? FetchPersonDetailsError else {
                    return false
                }
                if case .unknown = fetchError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - Helpers

    private func makeUseCase() -> DefaultFetchPersonDetailsUseCase {
        DefaultFetchPersonDetailsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigurationProvider
        )
    }

}
