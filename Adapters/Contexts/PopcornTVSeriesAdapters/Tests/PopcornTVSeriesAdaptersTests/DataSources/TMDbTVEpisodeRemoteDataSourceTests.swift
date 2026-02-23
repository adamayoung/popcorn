//
//  TMDbTVEpisodeRemoteDataSourceTests.swift
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

@Suite("TMDbTVEpisodeRemoteDataSource")
struct TMDbTVEpisodeRemoteDataSourceTests {

    let mockService: MockTVEpisodeService

    init() {
        self.mockService = MockTVEpisodeService()
    }

    @Test("episode maps response with all properties")
    func episodeMapsResponseWithAllProperties() async throws {
        let tmdbEpisode = TMDb.TVEpisode(
            id: 62085,
            name: "Pilot",
            episodeNumber: 1,
            seasonNumber: 1,
            overview: "A chemistry teacher begins cooking meth.",
            airDate: Date(timeIntervalSince1970: 1_200_000_000),
            runtime: 58,
            stillPath: URL(string: "/pilot.jpg")
        )
        mockService.detailsStub = .success(tmdbEpisode)

        let dataSource = TMDbTVEpisodeRemoteDataSource(tvEpisodeService: mockService)

        let result = try await dataSource.episode(1, inSeason: 1, inTVSeries: 1396)

        #expect(result.id == 62085)
        #expect(result.name == "Pilot")
        #expect(result.episodeNumber == 1)
        #expect(result.seasonNumber == 1)
        #expect(result.overview == "A chemistry teacher begins cooking meth.")
        #expect(result.runtime == 58)
        #expect(result.stillPath == URL(string: "/pilot.jpg"))
    }

    @Test("episode handles nil optionals")
    func episodeHandlesNilOptionals() async throws {
        let tmdbEpisode = TMDb.TVEpisode(
            id: 62085,
            name: "Pilot",
            episodeNumber: 1,
            seasonNumber: 1
        )
        mockService.detailsStub = .success(tmdbEpisode)

        let dataSource = TMDbTVEpisodeRemoteDataSource(tvEpisodeService: mockService)

        let result = try await dataSource.episode(1, inSeason: 1, inTVSeries: 1396)

        #expect(result.overview == nil)
        #expect(result.airDate == nil)
        #expect(result.runtime == nil)
        #expect(result.stillPath == nil)
    }

    @Test("episode calls service with correct parameters")
    func episodeCallsServiceWithCorrectParameters() async throws {
        let tmdbEpisode = TMDb.TVEpisode(
            id: 62085,
            name: "Episode 5",
            episodeNumber: 5,
            seasonNumber: 3
        )
        mockService.detailsStub = .success(tmdbEpisode)

        let dataSource = TMDbTVEpisodeRemoteDataSource(tvEpisodeService: mockService)

        _ = try await dataSource.episode(5, inSeason: 3, inTVSeries: 456)

        #expect(mockService.detailsCallCount == 1)
        #expect(mockService.detailsCalledWith[0].episodeNumber == 5)
        #expect(mockService.detailsCalledWith[0].seasonNumber == 3)
        #expect(mockService.detailsCalledWith[0].tvSeriesID == 456)
        #expect(mockService.detailsCalledWith[0].language == "en")
    }

    @Test("episode throws notFound for TMDb notFound")
    func episodeThrowsNotFoundForTMDbNotFound() async {
        mockService.detailsStub = .failure(.notFound())

        let dataSource = TMDbTVEpisodeRemoteDataSource(tvEpisodeService: mockService)

        await #expect(
            performing: {
                try await dataSource.episode(1, inSeason: 1, inTVSeries: 1396)
            },
            throws: { error in
                if case .notFound = error as? TVEpisodeRemoteDataSourceError {
                    return true
                }
                return false
            }
        )
    }

    @Test("episode throws unauthorised for TMDb unauthorised")
    func episodeThrowsUnauthorisedForTMDbUnauthorised() async {
        mockService.detailsStub = .failure(.unauthorised("Invalid API key"))

        let dataSource = TMDbTVEpisodeRemoteDataSource(tvEpisodeService: mockService)

        await #expect(
            performing: {
                try await dataSource.episode(1, inSeason: 1, inTVSeries: 1396)
            },
            throws: { error in
                if case .unauthorised = error as? TVEpisodeRemoteDataSourceError {
                    return true
                }
                return false
            }
        )
    }

    @Test("episode throws unknown for network TMDb error")
    func episodeThrowsUnknownForNetworkTMDbError() async {
        mockService.detailsStub = .failure(.network(TestError()))

        let dataSource = TMDbTVEpisodeRemoteDataSource(tvEpisodeService: mockService)

        await #expect(
            performing: {
                try await dataSource.episode(1, inSeason: 1, inTVSeries: 1396)
            },
            throws: { error in
                if case .unknown = error as? TVEpisodeRemoteDataSourceError {
                    return true
                }
                return false
            }
        )
    }

    @Test("episode throws unknown for unknown TMDb error")
    func episodeThrowsUnknownForUnknownTMDbError() async {
        mockService.detailsStub = .failure(.unknown)

        let dataSource = TMDbTVEpisodeRemoteDataSource(tvEpisodeService: mockService)

        await #expect(
            performing: {
                try await dataSource.episode(1, inSeason: 1, inTVSeries: 1396)
            },
            throws: { error in
                if case .unknown = error as? TVEpisodeRemoteDataSourceError {
                    return true
                }
                return false
            }
        )
    }

}

private extension TMDbTVEpisodeRemoteDataSourceTests {

    struct TestError: Error {}

}
