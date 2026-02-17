//
//  TMDbTrendingRemoteDataSourcePeopleTests.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTrendingAdapters
import Testing
import TMDb
import TrendingDomain
import TrendingInfrastructure

@Suite("TMDbTrendingRemoteDataSource People Tests")
struct TMDbTrendingRemoteDataSourcePeopleTests {

    let mockService: MockTrendingService

    init() {
        self.mockService = MockTrendingService()
    }

    @Test("people maps response and uses day time window with en language")
    func people_mapsResponseAndUsesDayTimeWindowWithEnLanguage() async throws {
        let profilePath = try #require(URL(string: "https://tmdb.example/profile.jpg"))

        let tmdbPeople = [
            PersonListItem(
                id: 287,
                name: "Brad Pitt",
                originalName: "Brad Pitt",
                knownForDepartment: "Acting",
                gender: .male,
                profilePath: profilePath,
                popularity: 54.123,
                knownFor: [],
                isAdultOnly: false
            )
        ]

        mockService.peopleStub = .success(
            PersonPageableList(
                page: 1,
                results: tmdbPeople,
                totalResults: 1,
                totalPages: 1
            )
        )

        let dataSource = TMDbTrendingRemoteDataSource(trendingService: mockService)

        let result = try await dataSource.people(page: 1)

        #expect(result.count == 1)
        #expect(result[0].id == 287)
        #expect(result[0].name == "Brad Pitt")
        #expect(result[0].knownForDepartment == "Acting")
        #expect(result[0].gender == .male)
        #expect(result[0].profilePath == profilePath)
        #expect(mockService.peopleCallCount == 1)
        #expect(mockService.peopleCalledWith[0].timeWindow == .day)
        #expect(mockService.peopleCalledWith[0].page == 1)
        #expect(mockService.peopleCalledWith[0].language == "en")
    }

    @Test("people returns empty array when no results")
    func people_returnsEmptyArrayWhenNoResults() async throws {
        mockService.peopleStub = .success(
            PersonPageableList(
                page: 1,
                results: [],
                totalResults: 0,
                totalPages: 0
            )
        )

        let dataSource = TMDbTrendingRemoteDataSource(trendingService: mockService)

        let result = try await dataSource.people(page: 1)

        #expect(result.isEmpty)
    }

    @Test("people throws unauthorised error for TMDb unauthorised")
    func people_throwsUnauthorisedErrorForTMDbUnauthorised() async {
        mockService.peopleStub = .failure(.unauthorised("No access"))

        let dataSource = TMDbTrendingRemoteDataSource(trendingService: mockService)

        await #expect(
            performing: {
                try await dataSource.people(page: 1)
            },
            throws: { error in
                guard let error = error as? TrendingRepositoryError else {
                    return false
                }

                if case .unauthorised = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("people throws unknown error for non mapped TMDb error")
    func people_throwsUnknownErrorForNonMappedTMDbError() async {
        mockService.peopleStub = .failure(.network(TestError()))

        let dataSource = TMDbTrendingRemoteDataSource(trendingService: mockService)

        await #expect(
            performing: {
                try await dataSource.people(page: 1)
            },
            throws: { error in
                guard let error = error as? TrendingRepositoryError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("people passes correct page number")
    func people_passesCorrectPageNumber() async throws {
        mockService.peopleStub = .success(
            PersonPageableList(page: 2, results: [], totalResults: 50, totalPages: 3)
        )

        let dataSource = TMDbTrendingRemoteDataSource(trendingService: mockService)

        _ = try await dataSource.people(page: 2)

        #expect(mockService.peopleCalledWith[0].page == 2)
    }

}

// MARK: - Test Helpers

private extension TMDbTrendingRemoteDataSourcePeopleTests {

    struct TestError: Error {}

}
