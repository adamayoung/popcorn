//
//  TMDbTVSeasonRemoteDataSourceTests.swift
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

@Suite("TMDbTVSeasonRemoteDataSource")
struct TMDbTVSeasonRemoteDataSourceTests {

    let mockService: MockTVSeasonService

    init() {
        self.mockService = MockTVSeasonService()
    }

    @Test("season maps response with overview and episodes")
    func seasonMapsResponseWithOverviewAndEpisodes() async throws {
        let tmdbSeason = TMDb.TVSeason(
            id: 3572,
            name: "Season 1",
            seasonNumber: 1,
            overview: "The first season of Breaking Bad.",
            episodes: [
                TMDb.TVEpisode(
                    id: 62085,
                    name: "Pilot",
                    episodeNumber: 1,
                    seasonNumber: 1,
                    overview: "A chemistry teacher begins cooking meth.",
                    stillPath: URL(string: "/pilot.jpg")
                ),
                TMDb.TVEpisode(
                    id: 62086,
                    name: "Cat's in the Bag...",
                    episodeNumber: 2,
                    seasonNumber: 1
                )
            ]
        )
        mockService.detailsStub = .success(tmdbSeason)

        let dataSource = TMDbTVSeasonRemoteDataSource(tvSeasonService: mockService)

        let result = try await dataSource.season(1, inTVSeries: 1396)

        #expect(result.id == 3572)
        #expect(result.name == "Season 1")
        #expect(result.seasonNumber == 1)
        #expect(result.overview == "The first season of Breaking Bad.")
        #expect(result.episodes.count == 2)
        #expect(result.episodes[0].id == 62085)
        #expect(result.episodes[0].name == "Pilot")
        #expect(result.episodes[1].id == 62086)
    }

    @Test("season handles nil episodes array")
    func seasonHandlesNilEpisodesArray() async throws {
        let tmdbSeason = TMDb.TVSeason(
            id: 3572,
            name: "Season 1",
            seasonNumber: 1,
            episodes: nil
        )
        mockService.detailsStub = .success(tmdbSeason)

        let dataSource = TMDbTVSeasonRemoteDataSource(tvSeasonService: mockService)

        let result = try await dataSource.season(1, inTVSeries: 1396)

        #expect(result.episodes.isEmpty)
    }

    @Test("season handles nil overview")
    func seasonHandlesNilOverview() async throws {
        let tmdbSeason = TMDb.TVSeason(
            id: 3572,
            name: "Season 1",
            seasonNumber: 1,
            overview: nil,
            episodes: []
        )
        mockService.detailsStub = .success(tmdbSeason)

        let dataSource = TMDbTVSeasonRemoteDataSource(tvSeasonService: mockService)

        let result = try await dataSource.season(1, inTVSeries: 1396)

        #expect(result.overview == nil)
    }

    @Test("season calls service with correct parameters")
    func seasonCallsServiceWithCorrectParameters() async throws {
        let tmdbSeason = TMDb.TVSeason(
            id: 3572,
            name: "Season 3",
            seasonNumber: 3,
            episodes: []
        )
        mockService.detailsStub = .success(tmdbSeason)

        let dataSource = TMDbTVSeasonRemoteDataSource(tvSeasonService: mockService)

        _ = try await dataSource.season(3, inTVSeries: 456)

        #expect(mockService.detailsCallCount == 1)
        #expect(mockService.detailsCalledWith[0].seasonNumber == 3)
        #expect(mockService.detailsCalledWith[0].tvSeriesID == 456)
        #expect(mockService.detailsCalledWith[0].language == "en")
    }

    @Test("season throws notFound for TMDb notFound")
    func seasonThrowsNotFoundForTMDbNotFound() async {
        mockService.detailsStub = .failure(.notFound())

        let dataSource = TMDbTVSeasonRemoteDataSource(tvSeasonService: mockService)

        await #expect(
            performing: {
                try await dataSource.season(1, inTVSeries: 1396)
            },
            throws: { error in
                if case .notFound = error as? TVSeasonRemoteDataSourceError {
                    return true
                }
                return false
            }
        )
    }

    @Test("season throws unauthorised for TMDb unauthorised")
    func seasonThrowsUnauthorisedForTMDbUnauthorised() async {
        mockService.detailsStub = .failure(.unauthorised("Invalid API key"))

        let dataSource = TMDbTVSeasonRemoteDataSource(tvSeasonService: mockService)

        await #expect(
            performing: {
                try await dataSource.season(1, inTVSeries: 1396)
            },
            throws: { error in
                if case .unauthorised = error as? TVSeasonRemoteDataSourceError {
                    return true
                }
                return false
            }
        )
    }

    @Test("season throws unknown for network TMDb error")
    func seasonThrowsUnknownForNetworkTMDbError() async {
        mockService.detailsStub = .failure(.network(TestError()))

        let dataSource = TMDbTVSeasonRemoteDataSource(tvSeasonService: mockService)

        await #expect(
            performing: {
                try await dataSource.season(1, inTVSeries: 1396)
            },
            throws: { error in
                if case .unknown = error as? TVSeasonRemoteDataSourceError {
                    return true
                }
                return false
            }
        )
    }

    @Test("season throws unknown for unknown TMDb error")
    func seasonThrowsUnknownForUnknownTMDbError() async {
        mockService.detailsStub = .failure(.unknown)

        let dataSource = TMDbTVSeasonRemoteDataSource(tvSeasonService: mockService)

        await #expect(
            performing: {
                try await dataSource.season(1, inTVSeries: 1396)
            },
            throws: { error in
                if case .unknown = error as? TVSeasonRemoteDataSourceError {
                    return true
                }
                return false
            }
        )
    }

}

private extension TMDbTVSeasonRemoteDataSourceTests {

    struct TestError: Error {}

}
