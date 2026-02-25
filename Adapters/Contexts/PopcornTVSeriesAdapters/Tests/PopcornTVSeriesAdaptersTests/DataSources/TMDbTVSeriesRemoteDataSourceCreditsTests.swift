//
//  TMDbTVSeriesRemoteDataSourceCreditsTests.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTVSeriesAdapters
import Testing
import TMDb
import TVSeriesDomain
import TVSeriesInfrastructure

@Suite("TMDbTVSeriesRemoteDataSource credits Tests")
struct TMDbTVSeriesRemoteDataSourceCreditsTests {

    let mockService: MockTVSeriesService

    init() {
        self.mockService = MockTVSeriesService()
    }

    // MARK: - credits Tests (Breaking Bad ID: 1396)

    @Test("credits maps response correctly using Breaking Bad")
    func creditsMapsResponseCorrectlyUsingBreakingBad() async throws {
        let tvSeriesID = 1396
        let castProfilePath = try #require(URL(string: "/rOVLq1rq97gMphuoiXP4YTBMbLT.jpg"))
        let crewProfilePath = try #require(URL(string: "/uFh3OrBvkiFKMeBpITfPjNFSAzq.jpg"))

        let tmdbCredits = TMDb.ShowCredits(
            id: tvSeriesID,
            cast: [
                TMDb.CastMember(
                    id: 17419,
                    creditID: "52542282760ee313280017f9",
                    name: "Bryan Cranston",
                    character: "Walter White",
                    gender: .male,
                    profilePath: castProfilePath,
                    order: 0
                )
            ],
            crew: [
                TMDb.CrewMember(
                    id: 66633,
                    creditID: "52542287760ee31328001af1",
                    name: "Vince Gilligan",
                    job: "Executive Producer",
                    department: "Production",
                    gender: .male,
                    profilePath: crewProfilePath
                )
            ]
        )

        mockService.creditsStub = .success(tmdbCredits)

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        let result = try await dataSource.credits(forTVSeries: tvSeriesID)

        #expect(result.id == tvSeriesID)
        #expect(result.cast.count == 1)
        #expect(result.cast[0].personName == "Bryan Cranston")
        #expect(result.cast[0].characterName == "Walter White")
        #expect(result.cast[0].id == "52542282760ee313280017f9")
        #expect(result.cast[0].personID == 17419)
        #expect(result.crew.count == 1)
        #expect(result.crew[0].personName == "Vince Gilligan")
        #expect(result.crew[0].job == "Executive Producer")
        #expect(mockService.creditsCallCount == 1)
        #expect(mockService.creditsCalledWith[0] == .init(tvSeriesID: tvSeriesID, language: nil))
    }

    @Test("credits maps empty arrays correctly")
    func creditsMapsEmptyArraysCorrectly() async throws {
        let tvSeriesID = 1396

        mockService.creditsStub = .success(
            TMDb.ShowCredits(
                id: tvSeriesID,
                cast: [],
                crew: []
            )
        )

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        let result = try await dataSource.credits(forTVSeries: tvSeriesID)

        #expect(result.id == tvSeriesID)
        #expect(result.cast.isEmpty)
        #expect(result.crew.isEmpty)
    }

    @Test("credits throws notFound error for TMDb notFound")
    func creditsThrowsNotFoundErrorForTMDbNotFound() async {
        let tvSeriesID = 1396

        mockService.creditsStub = .failure(.notFound())

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        await #expect(
            performing: {
                try await dataSource.credits(forTVSeries: tvSeriesID)
            },
            throws: { error in
                guard let error = error as? TVSeriesRemoteDataSourceError else {
                    return false
                }

                if case .notFound = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("credits throws unauthorised error for TMDb unauthorised")
    func creditsThrowsUnauthorisedErrorForTMDbUnauthorised() async {
        let tvSeriesID = 1396

        mockService.creditsStub = .failure(.unauthorised("Invalid API key"))

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        await #expect(
            performing: {
                try await dataSource.credits(forTVSeries: tvSeriesID)
            },
            throws: { error in
                guard let error = error as? TVSeriesRemoteDataSourceError else {
                    return false
                }

                if case .unauthorised = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("credits throws unknown error for network TMDb error")
    func creditsThrowsUnknownErrorForNetworkTMDbError() async {
        let tvSeriesID = 1396

        mockService.creditsStub = .failure(.network(TestError()))

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        await #expect(
            performing: {
                try await dataSource.credits(forTVSeries: tvSeriesID)
            },
            throws: { error in
                guard let error = error as? TVSeriesRemoteDataSourceError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("credits throws unknown error for unknown TMDb error")
    func creditsThrowsUnknownErrorForUnknownTMDbError() async {
        let tvSeriesID = 1396

        mockService.creditsStub = .failure(.unknown)

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        await #expect(
            performing: {
                try await dataSource.credits(forTVSeries: tvSeriesID)
            },
            throws: { error in
                guard let error = error as? TVSeriesRemoteDataSourceError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("credits calls service with correct tvSeriesID")
    func creditsCallsServiceWithCorrectTvSeriesID() async throws {
        let tvSeriesID = 1396

        mockService.creditsStub = .success(
            TMDb.ShowCredits(
                id: tvSeriesID,
                cast: [],
                crew: []
            )
        )

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        _ = try await dataSource.credits(forTVSeries: tvSeriesID)

        #expect(mockService.creditsCallCount == 1)
        #expect(mockService.creditsCalledWith[0].tvSeriesID == tvSeriesID)
    }

    @Test("credits calls service with nil language")
    func creditsCallsServiceWithNilLanguage() async throws {
        let tvSeriesID = 1396

        mockService.creditsStub = .success(
            TMDb.ShowCredits(
                id: tvSeriesID,
                cast: [],
                crew: []
            )
        )

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        _ = try await dataSource.credits(forTVSeries: tvSeriesID)

        #expect(mockService.creditsCalledWith[0].language == nil)
    }

}

// MARK: - Test Helpers

private extension TMDbTVSeriesRemoteDataSourceCreditsTests {

    struct TestError: Error {}

}
