//
//  DefaultFetchPersonKnownForUseCaseTests.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import CoreDomainTestHelpers
import Foundation
@testable import PeopleApplication
import PeopleDomain
import Testing

@Suite("DefaultFetchPersonKnownForUseCase")
struct DefaultFetchPersonKnownForUseCaseTests {

    let mockRepository: MockPersonRepository
    let mockAppConfigurationProvider: MockAppConfigurationProvider
    let mockMovieLogoImageProvider: MockMovieLogoImageProvider
    let mockTVSeriesLogoImageProvider: MockTVSeriesLogoImageProvider

    init() {
        self.mockRepository = MockPersonRepository()
        self.mockAppConfigurationProvider = MockAppConfigurationProvider()
        self.mockMovieLogoImageProvider = MockMovieLogoImageProvider()
        self.mockTVSeriesLogoImageProvider = MockTVSeriesLogoImageProvider()
        mockAppConfigurationProvider.appConfigurationStub = .success(AppConfiguration.mock())
    }

    // MARK: - Ranking

    @Test("returns an actor's cast credits ranked by popularity, capped at five")
    func returnsActorCastCreditsRankedTopFive() async throws {
        stubPerson(knownForDepartment: "Acting")
        let credits = (1 ... 7).map { index in
            PersonCredit.mock(
                id: index,
                title: "Movie \(index)",
                popularity: Double(index),
                role: .cast(character: nil)
            )
        }
        mockRepository.combinedCreditsStub = .success(credits)

        let result = try await makeUseCase().execute(personID: 1)

        #expect(result.count == 5)
        #expect(result.map(\.id) == [7, 6, 5, 4, 3])
    }

    @Test("returns a crew person's credits matching their known-for department")
    func returnsCrewCreditsMatchingDepartment() async throws {
        stubPerson(knownForDepartment: "Directing")
        let directing = PersonCredit.mock(id: 1, popularity: 5, role: .crew(job: "Director", department: "Directing"))
        let writing = PersonCredit.mock(id: 2, popularity: 9, role: .crew(job: "Writer", department: "Writing"))
        let acting = PersonCredit.mock(id: 3, popularity: 99, role: .cast(character: nil))
        mockRepository.combinedCreditsStub = .success([directing, writing, acting])

        let result = try await makeUseCase().execute(personID: 1)

        #expect(result.map(\.id) == [1])
    }

    @Test("falls back to all credits when the department filter selects nothing")
    func fallsBackToAllCreditsWhenDepartmentEmpty() async throws {
        stubPerson(knownForDepartment: "Directing")
        let castA = PersonCredit.mock(id: 1, popularity: 3, role: .cast(character: nil))
        let castB = PersonCredit.mock(id: 2, popularity: 8, role: .cast(character: nil))
        mockRepository.combinedCreditsStub = .success([castA, castB])

        let result = try await makeUseCase().execute(personID: 1)

        #expect(Set(result.map(\.id)) == [1, 2])
    }

    @Test("drops credits that have no backdrop")
    func dropsCreditsWithoutBackdrop() async throws {
        stubPerson(knownForDepartment: "Acting")
        let withBackdrop = PersonCredit.mock(id: 1, backdropPath: URL(string: "/b.jpg"), role: .cast(character: nil))
        let withoutBackdrop = PersonCredit.mock(id: 2, backdropPath: nil, popularity: 99, role: .cast(character: nil))
        mockRepository.combinedCreditsStub = .success([withBackdrop, withoutBackdrop])

        let result = try await makeUseCase().execute(personID: 1)

        #expect(result.map(\.id) == [1])
    }

    @Test("deduplicates a repeated title keeping the more popular instance")
    func deduplicatesKeepingMorePopular() async throws {
        stubPerson(knownForDepartment: "Acting")
        let lowPopularity = PersonCredit.mock(id: 10, title: "Old", popularity: 5, role: .cast(character: nil))
        let highPopularity = PersonCredit.mock(id: 10, title: "New", popularity: 9, role: .cast(character: nil))
        mockRepository.combinedCreditsStub = .success([lowPopularity, highPopularity])

        let result = try await makeUseCase().execute(personID: 1)

        #expect(result.count == 1)
        #expect(result[0].title == "New")
    }

    // MARK: - Logo Enrichment

    @Test("fetches logos only for the capped set of credits")
    func fetchesLogosOnlyForCappedSet() async throws {
        stubPerson(knownForDepartment: "Acting")
        let credits = (1 ... 7).map {
            PersonCredit.mock(id: $0, popularity: Double($0), role: .cast(character: nil))
        }
        mockRepository.combinedCreditsStub = .success(credits)

        _ = try await makeUseCase().execute(personID: 1)

        #expect(mockMovieLogoImageProvider.imageURLSetCallCount == 5)
    }

    @Test("attaches a fetched logo to its item")
    func attachesFetchedLogoToItem() async throws {
        stubPerson(knownForDepartment: "Acting")
        mockRepository.combinedCreditsStub = .success([PersonCredit.mock(id: 3, role: .cast(character: nil))])
        let logoURLSet = try #require(ImagesConfiguration.mock().logoURLSet(for: URL(string: "/logo.png")))
        mockMovieLogoImageProvider.imageURLSetStubs[3] = .success(logoURLSet)

        let result = try await makeUseCase().execute(personID: 1)

        #expect(result[0].logoURLSet == logoURLSet)
    }

    @Test("keeps an item with a nil logo when its logo fetch fails")
    func keepsItemWhenLogoFetchFails() async throws {
        stubPerson(knownForDepartment: "Acting")
        mockRepository.combinedCreditsStub = .success([PersonCredit.mock(id: 3, role: .cast(character: nil))])
        mockMovieLogoImageProvider.imageURLSetStubs[3] = .failure(.notFound)

        let result = try await makeUseCase().execute(personID: 1)

        #expect(result.count == 1)
        #expect(result[0].logoURLSet == nil)
    }

    @Test("routes a TV series credit's logo fetch to the TV series provider")
    func routesTVSeriesLogoToTVSeriesProvider() async throws {
        stubPerson(knownForDepartment: "Acting")
        mockRepository.combinedCreditsStub = .success([
            PersonCredit.mock(id: 8, mediaType: .tvSeries, role: .cast(character: nil))
        ])
        let logoURLSet = try #require(ImagesConfiguration.mock().logoURLSet(for: URL(string: "/logo.png")))
        mockTVSeriesLogoImageProvider.imageURLSetStubs[8] = .success(logoURLSet)

        let result = try await makeUseCase().execute(personID: 1)

        #expect(result[0].logoURLSet == logoURLSet)
        #expect(mockTVSeriesLogoImageProvider.imageURLSetCalledWith == [8])
        #expect(mockMovieLogoImageProvider.imageURLSetCallCount == 0)
    }

    // MARK: - Error Translation

    @Test("translates a combined-credits notFound error")
    func translatesCombinedCreditsNotFound() async {
        stubPerson(knownForDepartment: "Acting")
        mockRepository.combinedCreditsStub = .failure(.notFound)

        await expectError(.notFound)
    }

    @Test("translates an app-configuration unauthorised error")
    func translatesAppConfigurationUnauthorised() async {
        stubPerson(knownForDepartment: "Acting")
        mockRepository.combinedCreditsStub = .success([PersonCredit.mock()])
        mockAppConfigurationProvider.appConfigurationStub = .failure(.unauthorised)

        await expectError(.unauthorised)
    }

    @Test("translates a person-fetch unknown error")
    func translatesPersonFetchUnknown() async {
        mockRepository.personStub = .failure(.unknown(NSError(domain: "test", code: 1)))
        mockRepository.combinedCreditsStub = .success([PersonCredit.mock()])

        await expectError(.unknown(nil))
    }

    // MARK: - Helpers

    private func stubPerson(knownForDepartment: String) {
        mockRepository.personStub = .success(Person.mock(knownForDepartment: knownForDepartment))
    }

    private func makeUseCase() -> DefaultFetchPersonKnownForUseCase {
        DefaultFetchPersonKnownForUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigurationProvider,
            movieLogoImageProvider: mockMovieLogoImageProvider,
            tvSeriesLogoImageProvider: mockTVSeriesLogoImageProvider
        )
    }

    private func expectError(_ expected: FetchPersonKnownForError) async {
        await #expect(
            performing: { try await makeUseCase().execute(personID: 1) },
            throws: { error in
                guard let error = error as? FetchPersonKnownForError else {
                    return false
                }
                return error.matches(expected)
            }
        )
    }

}

private extension FetchPersonKnownForError {

    func matches(_ other: FetchPersonKnownForError) -> Bool {
        switch (self, other) {
        case (.notFound, .notFound), (.unauthorised, .unauthorised), (.unknown, .unknown):
            true
        default:
            false
        }
    }

}
