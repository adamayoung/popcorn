//
//  TMDbTVEpisodeRemoteDataSourceCreditsTests.swift
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

@Suite("TMDbTVEpisodeRemoteDataSource credits Tests")
struct TMDbTVEpisodeRemoteDataSourceCreditsTests {

    let mockService: MockTVEpisodeService

    init() {
        self.mockService = MockTVEpisodeService()
    }

    @Test("credits maps response correctly")
    func creditsMapsResponseCorrectly() async throws {
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

        let dataSource = TMDbTVEpisodeRemoteDataSource(tvEpisodeService: mockService)

        let result = try await dataSource.credits(forEpisode: 1, inSeason: 1, inTVSeries: tvSeriesID)

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
        #expect(mockService.creditsCalledWith[0] == .init(
            episodeNumber: 1,
            seasonNumber: 1,
            tvSeriesID: tvSeriesID,
            language: nil
        ))
    }

    @Test("credits maps empty arrays correctly")
    func creditsMapsEmptyArraysCorrectly() async throws {
        let tvSeriesID = 1396

        mockService.creditsStub = .success(
            TMDb.ShowCredits(id: tvSeriesID, cast: [], crew: [])
        )

        let dataSource = TMDbTVEpisodeRemoteDataSource(tvEpisodeService: mockService)

        let result = try await dataSource.credits(forEpisode: 1, inSeason: 1, inTVSeries: tvSeriesID)

        #expect(result.id == tvSeriesID)
        #expect(result.cast.isEmpty)
        #expect(result.crew.isEmpty)
    }

    @Test("credits throws notFound error for TMDb notFound")
    func creditsThrowsNotFoundErrorForTMDbNotFound() async {
        mockService.creditsStub = .failure(.notFound())

        let dataSource = TMDbTVEpisodeRemoteDataSource(tvEpisodeService: mockService)

        await #expect(
            performing: {
                try await dataSource.credits(forEpisode: 1, inSeason: 1, inTVSeries: 1396)
            },
            throws: { error in
                guard let error = error as? TVEpisodeRemoteDataSourceError else {
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
        mockService.creditsStub = .failure(.unauthorised("Invalid API key"))

        let dataSource = TMDbTVEpisodeRemoteDataSource(tvEpisodeService: mockService)

        await #expect(
            performing: {
                try await dataSource.credits(forEpisode: 1, inSeason: 1, inTVSeries: 1396)
            },
            throws: { error in
                guard let error = error as? TVEpisodeRemoteDataSourceError else {
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
        mockService.creditsStub = .failure(.network(TestError()))

        let dataSource = TMDbTVEpisodeRemoteDataSource(tvEpisodeService: mockService)

        await #expect(
            performing: {
                try await dataSource.credits(forEpisode: 1, inSeason: 1, inTVSeries: 1396)
            },
            throws: { error in
                guard let error = error as? TVEpisodeRemoteDataSourceError else {
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
        mockService.creditsStub = .failure(.unknown)

        let dataSource = TMDbTVEpisodeRemoteDataSource(tvEpisodeService: mockService)

        await #expect(
            performing: {
                try await dataSource.credits(forEpisode: 1, inSeason: 1, inTVSeries: 1396)
            },
            throws: { error in
                guard let error = error as? TVEpisodeRemoteDataSourceError else {
                    return false
                }
                if case .unknown = error {
                    return true
                }
                return false
            }
        )
    }

    @Test("credits calls service with correct parameters")
    func creditsCallsServiceWithCorrectParameters() async throws {
        mockService.creditsStub = .success(
            TMDb.ShowCredits(id: 1396, cast: [], crew: [])
        )

        let dataSource = TMDbTVEpisodeRemoteDataSource(tvEpisodeService: mockService)

        _ = try await dataSource.credits(forEpisode: 5, inSeason: 3, inTVSeries: 1396)

        #expect(mockService.creditsCallCount == 1)
        let call = try #require(mockService.creditsCalledWith.first)
        #expect(call.episodeNumber == 5)
        #expect(call.seasonNumber == 3)
        #expect(call.tvSeriesID == 1396)
        #expect(call.language == nil)
    }

}

// MARK: - Test Helpers

private extension TMDbTVEpisodeRemoteDataSourceCreditsTests {

    struct TestError: Error {}

}
