//
//  MockTVSeriesService.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TMDb

final class MockTVSeriesService: TVSeriesService, @unchecked Sendable {

    struct DetailsCall: Equatable {
        let id: Int
        let language: String?
    }

    struct ImagesCall {
        let tvSeriesID: Int
        let filter: TVSeriesImageFilter?
    }

    var detailsCallCount = 0
    var detailsCalledWith: [DetailsCall] = []
    var detailsStub: Result<TVSeries, TMDbError>?

    var imagesCallCount = 0
    var imagesCalledWith: [ImagesCall] = []
    var imagesStub: Result<ImageCollection, TMDbError>?

    func details(forTVSeries id: TVSeries.ID, language: String?) async throws -> TVSeries {
        detailsCallCount += 1
        detailsCalledWith.append(DetailsCall(id: id, language: language))

        guard let stub = detailsStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let tvSeries):
            return tvSeries
        case .failure(let error):
            throw error
        }
    }

    func credits(forTVSeries tvSeriesID: TVSeries.ID, language: String?) async throws -> ShowCredits {
        fatalError("Not implemented")
    }

    func aggregateCredits(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws -> TVSeriesAggregateCredits {
        fatalError("Not implemented")
    }

    func reviews(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int?,
        language: String?
    ) async throws -> ReviewPageableList {
        fatalError("Not implemented")
    }

    func images(
        forTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeriesImageFilter?
    ) async throws -> ImageCollection {
        imagesCallCount += 1
        imagesCalledWith.append(ImagesCall(tvSeriesID: tvSeriesID, filter: filter))

        guard let stub = imagesStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let imageCollection):
            return imageCollection
        case .failure(let error):
            throw error
        }
    }

    func videos(
        forTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeriesVideoFilter?
    ) async throws -> VideoCollection {
        fatalError("Not implemented")
    }

    func recommendations(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int?,
        language: String?
    ) async throws -> TVSeriesPageableList {
        fatalError("Not implemented")
    }

    func similar(
        toTVSeries tvSeriesID: TVSeries.ID,
        page: Int?,
        language: String?
    ) async throws -> TVSeriesPageableList {
        fatalError("Not implemented")
    }

    func popular(page: Int?, language: String?) async throws -> TVSeriesPageableList {
        fatalError("Not implemented")
    }

    func watchProviders(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> [ShowWatchProvidersByCountry] {
        fatalError("Not implemented")
    }

    func externalLinks(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> TVSeriesExternalLinksCollection {
        fatalError("Not implemented")
    }

    func contentRatings(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> [ContentRating] {
        fatalError("Not implemented")
    }

    func airingToday(
        page: Int?,
        timezone: String?,
        language: String?
    ) async throws -> TVSeriesPageableList {
        fatalError("Not implemented")
    }

    func onTheAir(
        page: Int?,
        timezone: String?,
        language: String?
    ) async throws -> TVSeriesPageableList {
        fatalError("Not implemented")
    }

    func topRated(
        page: Int?,
        language: String?
    ) async throws -> TVSeriesPageableList {
        fatalError("Not implemented")
    }

}
