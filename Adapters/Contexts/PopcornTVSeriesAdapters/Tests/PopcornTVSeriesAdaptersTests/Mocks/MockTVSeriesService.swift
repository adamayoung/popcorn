//
//  MockTVSeriesService.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
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

    struct CreditsCall: Equatable {
        let tvSeriesID: Int
        let language: String?
    }

    struct AggregateCreditsCall: Equatable {
        let tvSeriesID: Int
        let language: String?
    }

    var detailsCallCount = 0
    var detailsCalledWith: [DetailsCall] = []
    var detailsStub: Result<TVSeries, TMDbError>?

    var imagesCallCount = 0
    var imagesCalledWith: [ImagesCall] = []
    var imagesStub: Result<ImageCollection, TMDbError>?

    var creditsCallCount = 0
    var creditsCalledWith: [CreditsCall] = []
    var creditsStub: Result<ShowCredits, TMDbError>?

    var aggregateCreditsCallCount = 0
    var aggregateCreditsCalledWith: [AggregateCreditsCall] = []
    var aggregateCreditsStub: Result<TVSeriesAggregateCredits, TMDbError>?

    func details(forTVSeries id: TVSeries.ID, language: String?) async throws(TMDbError) -> TVSeries {
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

    func details(
        forTVSeries tvSeriesID: TVSeries.ID,
        appending: TVSeriesAppendOption,
        language: String?
    ) async throws(TMDbError) -> TVSeriesDetailsResponse {
        fatalError("Not implemented")
    }

    func credits(forTVSeries tvSeriesID: TVSeries.ID, language: String?) async throws(TMDbError) -> ShowCredits {
        creditsCallCount += 1
        creditsCalledWith.append(CreditsCall(tvSeriesID: tvSeriesID, language: language))

        guard let stub = creditsStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let credits):
            return credits
        case .failure(let error):
            throw error
        }
    }

    func aggregateCredits(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws(TMDbError) -> TVSeriesAggregateCredits {
        aggregateCreditsCallCount += 1
        aggregateCreditsCalledWith.append(
            AggregateCreditsCall(tvSeriesID: tvSeriesID, language: language)
        )

        guard let stub = aggregateCreditsStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let credits):
            return credits
        case .failure(let error):
            throw error
        }
    }

    func reviews(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> ReviewPageableList {
        fatalError("Not implemented")
    }

    func images(
        forTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeriesImageFilter?
    ) async throws(TMDbError) -> ImageCollection {
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
    ) async throws(TMDbError) -> VideoCollection {
        fatalError("Not implemented")
    }

    func recommendations(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        fatalError("Not implemented")
    }

    func similar(
        toTVSeries tvSeriesID: TVSeries.ID,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        fatalError("Not implemented")
    }

    func popular(page: Int?, language: String?) async throws(TMDbError) -> TVSeriesPageableList {
        fatalError("Not implemented")
    }

    func airingToday(
        page: Int?,
        timezone: String?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        fatalError("Not implemented")
    }

    func onTheAir(
        page: Int?,
        timezone: String?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        fatalError("Not implemented")
    }

    func topRated(
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        fatalError("Not implemented")
    }

    func watchProviders(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> [ShowWatchProvidersByCountry] {
        fatalError("Not implemented")
    }

    func externalLinks(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> TVSeriesExternalLinksCollection {
        fatalError("Not implemented")
    }

    func contentRatings(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> [ContentRating] {
        fatalError("Not implemented")
    }

    func accountStates(forTVSeries tvSeriesID: TVSeries.ID, session: Session) async throws(TMDbError) -> AccountStates {
        fatalError("Not implemented")
    }

    func addRating(_ rating: Double, toTVSeries tvSeriesID: TVSeries.ID, session: Session) async throws(TMDbError) {
        fatalError("Not implemented")
    }

    func deleteRating(forTVSeries tvSeriesID: TVSeries.ID, session: Session) async throws(TMDbError) {
        fatalError("Not implemented")
    }

    func keywords(forTVSeries tvSeriesID: TVSeries.ID) async throws(TMDbError) -> KeywordCollection {
        fatalError("Not implemented")
    }

    func alternativeTitles(forTVSeries tvSeriesID: TVSeries.ID) async throws(TMDbError) -> AlternativeTitleCollection {
        fatalError("Not implemented")
    }

    func translations(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> TranslationCollection<TVSeriesTranslationData> {
        fatalError("Not implemented")
    }

    func lists(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MediaListSummaryPageableList {
        fatalError("Not implemented")
    }

    func changes(
        forTVSeries tvSeriesID: TVSeries.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        fatalError("Not implemented")
    }

    func latest() async throws(TMDbError) -> TVSeries {
        fatalError("Not implemented")
    }

    func changes(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangedIDCollection {
        fatalError("Not implemented")
    }

    func screenedTheatrically(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> ScreenedTheatricallyCollection {
        fatalError("Not implemented")
    }

    func episodeGroups(forTVSeries tvSeriesID: TVSeries.ID) async throws(TMDbError) -> TVEpisodeGroupCollection {
        fatalError("Not implemented")
    }

}
