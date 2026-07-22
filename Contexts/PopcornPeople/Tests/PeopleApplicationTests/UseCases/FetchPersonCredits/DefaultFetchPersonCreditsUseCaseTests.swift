//
//  DefaultFetchPersonCreditsUseCaseTests.swift
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

@Suite("DefaultFetchPersonCreditsUseCase")
struct DefaultFetchPersonCreditsUseCaseTests {

    let mockRepository: MockPersonRepository
    let mockAppConfigurationProvider: MockAppConfigurationProvider

    init() {
        self.mockRepository = MockPersonRepository()
        self.mockAppConfigurationProvider = MockAppConfigurationProvider()
        mockAppConfigurationProvider.appConfigurationStub = .success(AppConfiguration.mock())
    }

    // MARK: - Grouping

    @Test("returns one item per unique media type and id")
    func returnsOneItemPerUniqueMediaTypeAndID() async throws {
        mockRepository.combinedCreditsStub = .success([
            PersonCredit.mock(id: 1, title: "A", role: .cast(character: "Hero")),
            PersonCredit.mock(id: 2, title: "B", role: .cast(character: "Villain"))
        ])

        let result = try await makeUseCase().execute(personID: 1)

        #expect(result.map(\.id) == [1, 2])
    }

    @Test("merges same-title cast and crew credits, characters before jobs")
    func mergesSameTitleCreditsCharactersBeforeJobs() async throws {
        mockRepository.combinedCreditsStub = .success([
            PersonCredit.mock(id: 1, role: .crew(job: "Executive Producer", department: "Production")),
            PersonCredit.mock(id: 1, role: .cast(character: "Tony Stark"))
        ])

        let result = try await makeUseCase().execute(personID: 1)

        #expect(result.count == 1)
        #expect(result[0].parts == ["Tony Stark", "Executive Producer"])
    }

    @Test("does not merge a movie and a TV series sharing the same id")
    func doesNotMergeMovieAndTVSeriesSharingID() async throws {
        mockRepository.combinedCreditsStub = .success([
            PersonCredit.mock(id: 7, mediaType: .movie, title: "Movie", role: .cast(character: "A")),
            PersonCredit.mock(id: 7, mediaType: .tvSeries, title: "Series", role: .cast(character: "B"))
        ])

        let result = try await makeUseCase().execute(personID: 1)

        #expect(result.count == 2)
    }

    // MARK: - Sorting

    @Test("sorts newest first by date")
    func sortsNewestFirstByDate() async throws {
        let older = Date(timeIntervalSince1970: 1_000_000)
        let newer = Date(timeIntervalSince1970: 2_000_000)
        mockRepository.combinedCreditsStub = .success([
            PersonCredit.mock(id: 1, releaseDate: older),
            PersonCredit.mock(id: 2, releaseDate: newer)
        ])

        let result = try await makeUseCase().execute(personID: 1)

        #expect(result.map(\.id) == [2, 1])
    }

    @Test("sorts undated credits first")
    func sortsUndatedCreditsFirst() async throws {
        let dated = Date(timeIntervalSince1970: 2_000_000)
        mockRepository.combinedCreditsStub = .success([
            PersonCredit.mock(id: 1, releaseDate: dated),
            PersonCredit.mock(id: 2, releaseDate: nil)
        ])

        let result = try await makeUseCase().execute(personID: 1)

        #expect(result.map(\.id) == [2, 1])
    }

    @Test("breaks a date tie by title, then id")
    func breaksDateTieByTitleThenID() async throws {
        let date = Date(timeIntervalSince1970: 1_000_000)
        mockRepository.combinedCreditsStub = .success([
            PersonCredit.mock(id: 3, title: "Zebra", releaseDate: date),
            PersonCredit.mock(id: 2, title: "Apple", releaseDate: date),
            PersonCredit.mock(id: 1, title: "Apple", releaseDate: date)
        ])

        let result = try await makeUseCase().execute(personID: 1)

        #expect(result.map(\.id) == [1, 2, 3])
    }

    // MARK: - Result Content

    @Test("returns an empty list when the person has no credits")
    func returnsEmptyListForNoCredits() async throws {
        mockRepository.combinedCreditsStub = .success([])

        let result = try await makeUseCase().execute(personID: 1)

        #expect(result.isEmpty)
    }

    // MARK: - Error Translation

    @Test("translates a combined-credits notFound error")
    func translatesCombinedCreditsNotFound() async {
        mockRepository.combinedCreditsStub = .failure(.notFound)

        await expectError(.notFound)
    }

    @Test("translates a combined-credits unauthorised error")
    func translatesCombinedCreditsUnauthorised() async {
        mockRepository.combinedCreditsStub = .failure(.unauthorised)

        await expectError(.unauthorised)
    }

    @Test("translates a combined-credits unknown error")
    func translatesCombinedCreditsUnknown() async {
        mockRepository.combinedCreditsStub = .failure(.unknown(NSError(domain: "test", code: 1)))

        await expectError(.unknown(nil))
    }

    @Test("translates an app-configuration unauthorised error")
    func translatesAppConfigurationUnauthorised() async {
        mockRepository.combinedCreditsStub = .success([PersonCredit.mock()])
        mockAppConfigurationProvider.appConfigurationStub = .failure(.unauthorised)

        await expectError(.unauthorised)
    }

    // MARK: - Helpers

    private func makeUseCase() -> DefaultFetchPersonCreditsUseCase {
        DefaultFetchPersonCreditsUseCase(
            repository: mockRepository,
            appConfigurationProvider: mockAppConfigurationProvider
        )
    }

    private func expectError(_ expected: FetchPersonCreditsError) async {
        await #expect(
            performing: { try await makeUseCase().execute(personID: 1) },
            throws: { error in
                guard let error = error as? FetchPersonCreditsError else {
                    return false
                }
                return error.matches(expected)
            }
        )
    }

}

private extension FetchPersonCreditsError {

    func matches(_ other: FetchPersonCreditsError) -> Bool {
        switch (self, other) {
        case (.notFound, .notFound), (.unauthorised, .unauthorised), (.unknown, .unknown):
            true
        default:
            false
        }
    }

}
