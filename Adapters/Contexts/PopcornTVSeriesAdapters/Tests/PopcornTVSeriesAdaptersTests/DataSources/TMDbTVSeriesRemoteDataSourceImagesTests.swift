//
//  TMDbTVSeriesRemoteDataSourceImagesTests.swift
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

@Suite("TMDbTVSeriesRemoteDataSource images Tests")
struct TMDbTVSeriesRemoteDataSourceImagesTests {

    let mockService: MockTVSeriesService

    init() {
        self.mockService = MockTVSeriesService()
    }

    // MARK: - images Tests (Breaking Bad ID: 1396)

    @Test("images maps response and uses en language filter using Breaking Bad")
    func imagesMapsResponseAndUsesEnglishFilterUsingBreakingBad() async throws {
        let tvSeriesID = 1396
        let poster = try makeImageMetadata(path: "/3xnWaLQjelJDDF7LT1WBo6f4BRe.jpg")
        let backdrop = try makeImageMetadata(path: "/tsRy63Mu5cu8etL1X7ZLyf7UP1M.jpg")
        let logo = try makeImageMetadata(path: "/y2p9BpuWYdzfG9SH7o3GEu7kxCW.png")

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

    @Test("images maps empty arrays correctly")
    func imagesMapsEmptyArraysCorrectly() async throws {
        let tvSeriesID = 1396

        mockService.imagesStub = .success(
            ImageCollection(
                id: tvSeriesID,
                posters: [],
                logos: [],
                backdrops: []
            )
        )

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        let result = try await dataSource.images(forTVSeries: tvSeriesID)

        #expect(result.id == tvSeriesID)
        #expect(result.posterPaths.isEmpty)
        #expect(result.backdropPaths.isEmpty)
        #expect(result.logoPaths.isEmpty)
    }

    @Test("images maps multiple images correctly")
    func imagesMapsMultipleImagesCorrectly() async throws {
        let tvSeriesID = 1396
        let poster1 = try makeImageMetadata(path: "/poster1.jpg")
        let poster2 = try makeImageMetadata(path: "/poster2.jpg")
        let backdrop1 = try makeImageMetadata(path: "/backdrop1.jpg")
        let backdrop2 = try makeImageMetadata(path: "/backdrop2.jpg")
        let logo1 = try makeImageMetadata(path: "/logo1.png")
        let logo2 = try makeImageMetadata(path: "/logo2.png")

        mockService.imagesStub = .success(
            ImageCollection(
                id: tvSeriesID,
                posters: [poster1, poster2],
                logos: [logo1, logo2],
                backdrops: [backdrop1, backdrop2]
            )
        )

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        let result = try await dataSource.images(forTVSeries: tvSeriesID)

        #expect(result.posterPaths.count == 2)
        #expect(result.backdropPaths.count == 2)
        #expect(result.logoPaths.count == 2)
    }

    @Test("images throws notFound error for TMDb notFound")
    func imagesThrowsNotFoundErrorForTMDbNotFound() async {
        let tvSeriesID = 1396

        mockService.imagesStub = .failure(.notFound())

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        await #expect(
            performing: {
                try await dataSource.images(forTVSeries: tvSeriesID)
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

    @Test("images throws unauthorised error for TMDb unauthorised")
    func imagesThrowsUnauthorisedErrorForTMDbUnauthorised() async {
        let tvSeriesID = 1396

        mockService.imagesStub = .failure(.unauthorised("Invalid API key"))

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

    @Test("images throws unknown error for network TMDb error")
    func imagesThrowsUnknownErrorForNetworkTMDbError() async {
        let tvSeriesID = 1396

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

    @Test("images throws unknown error for unknown TMDb error")
    func imagesThrowsUnknownErrorForUnknownTMDbError() async {
        let tvSeriesID = 1396

        mockService.imagesStub = .failure(.unknown)

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

    @Test("images calls service with correct tvSeriesID")
    func imagesCallsServiceWithCorrectTvSeriesID() async throws {
        let tvSeriesID = 1396

        mockService.imagesStub = .success(
            ImageCollection(
                id: tvSeriesID,
                posters: [],
                logos: [],
                backdrops: []
            )
        )

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        _ = try await dataSource.images(forTVSeries: tvSeriesID)

        #expect(mockService.imagesCallCount == 1)
        #expect(mockService.imagesCalledWith[0].tvSeriesID == tvSeriesID)
    }

    @Test("images calls service with en language filter")
    func imagesCallsServiceWithEnLanguageFilter() async throws {
        let tvSeriesID = 1396

        mockService.imagesStub = .success(
            ImageCollection(
                id: tvSeriesID,
                posters: [],
                logos: [],
                backdrops: []
            )
        )

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        _ = try await dataSource.images(forTVSeries: tvSeriesID)

        #expect(mockService.imagesCalledWith[0].filter?.languages == ["en"])
    }

}

// MARK: - Test Helpers

private extension TMDbTVSeriesRemoteDataSourceImagesTests {

    struct TestError: Error {}

    func makeImageMetadata(path: String) throws -> ImageMetadata {
        try ImageMetadata(
            filePath: #require(URL(string: path)),
            width: 500,
            height: 750,
            aspectRatio: 0.66,
            voteAverage: nil,
            voteCount: nil
        )
    }

}
