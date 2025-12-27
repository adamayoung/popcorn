//
//  TMDbTVSeriesRemoteDataSourceTests.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import Testing
import TMDb
import TVSeriesDomain

@testable import PopcornTVSeriesAdapters

@Suite("TMDbTVSeriesRemoteDataSource Tests")
struct TMDbTVSeriesRemoteDataSourceTests {

    let mockService: MockTVSeriesService

    init() {
        self.mockService = MockTVSeriesService()
    }

    @Test("tvSeries maps response and uses en language")
    func tvSeries_mapsResponseAndUsesEnglishLanguage() async throws {
        let id = 42
        let posterPath = try #require(URL(string: "https://tmdb.example/poster.jpg"))
        let backdropPath = try #require(URL(string: "https://tmdb.example/backdrop.jpg"))
        let firstAirDate = Date(timeIntervalSince1970: 1_200_528_000)
        let tmdbTVSeries = TMDb.TVSeries(
            id: id,
            name: "Signal",
            overview: "A detective drama",
            firstAirDate: firstAirDate,
            posterPath: posterPath,
            backdropPath: backdropPath
        )

        mockService.detailsStub = .success(tmdbTVSeries)

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        let result = try await dataSource.tvSeries(withID: id)

        #expect(result == TVSeries(
            id: id,
            name: "Signal",
            overview: "A detective drama",
            firstAirDate: firstAirDate,
            posterPath: posterPath,
            backdropPath: backdropPath
        ))
        #expect(mockService.detailsCallCount == 1)
        #expect(mockService.detailsCalledWith[0] == .init(id: id, language: "en"))
    }

    @Test("tvSeries throws notFound error for TMDb notFound")
    func tvSeries_throwsNotFoundErrorForTMDbNotFound() async {
        let id = 13

        mockService.detailsStub = .failure(.notFound)

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        await #expect(
            performing: {
                try await dataSource.tvSeries(withID: id)
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

    @Test("tvSeries throws unauthorised error for TMDb unauthorised")
    func tvSeries_throwsUnauthorisedErrorForTMDbUnauthorised() async {
        let id = 17

        mockService.detailsStub = .failure(.unauthorised("No access"))

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        await #expect(
            performing: {
                try await dataSource.tvSeries(withID: id)
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

    @Test("images maps response and uses en language filter")
    func images_mapsResponseAndUsesEnglishFilter() async throws {
        let tvSeriesID = 88
        let poster = try makeImageMetadata(path: "https://tmdb.example/poster.jpg")
        let backdrop = try makeImageMetadata(path: "https://tmdb.example/backdrop.jpg")
        let logo = try makeImageMetadata(path: "https://tmdb.example/logo.jpg")

        mockService.imagesStub = .success(
            ImageCollection(
                id: tvSeriesID,
                posters: [poster],
                logos: [logo],
                backdrops: [backdrop]
            )
        )

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        let result = try await dataSource.images(forTVSeries: tvSeriesID)

        #expect(result.id == tvSeriesID)
        #expect(result.posterPaths == [poster.filePath])
        #expect(result.backdropPaths == [backdrop.filePath])
        #expect(result.logoPaths == [logo.filePath])
        #expect(mockService.imagesCallCount == 1)
        #expect(mockService.imagesCalledWith[0].filter?.languages == ["en"])
    }

    @Test("images throws unauthorised error for TMDb unauthorised")
    func images_throwsUnauthorisedErrorForTMDbUnauthorised() async {
        let tvSeriesID = 29

        mockService.imagesStub = .failure(.unauthorised("No access"))

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        await #expect(
            performing: {
                try await dataSource.images(forTVSeries: tvSeriesID)
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

    @Test("images throws unknown error for non mapped TMDb error")
    func images_throwsUnknownErrorForNonMappedTMDbError() async {
        let tvSeriesID = 31

        mockService.imagesStub = .failure(.network(TestError()))

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        await #expect(
            performing: {
                try await dataSource.images(forTVSeries: tvSeriesID)
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

}

private extension TMDbTVSeriesRemoteDataSourceTests {

    struct TestError: Error {}

    func makeImageMetadata(path: String) throws -> ImageMetadata {
        try ImageMetadata(
            filePath: #require(URL(string: path)),
            width: 300,
            height: 450,
            aspectRatio: 0.66,
            voteAverage: nil,
            voteCount: nil
        )
    }

}
