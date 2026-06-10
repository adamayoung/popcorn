//
//  MockTVSeasonService.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

final class MockTVSeasonService: TVSeasonService, @unchecked Sendable {

    struct DetailsCall: Equatable {
        let seasonNumber: Int
        let tvSeriesID: Int
        let language: String?
    }

    var detailsCallCount = 0
    var detailsCalledWith: [DetailsCall] = []
    var detailsStub: Result<TVSeason, TMDbError>?

    func details(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws(TMDbError) -> TVSeason {
        detailsCallCount += 1
        detailsCalledWith.append(DetailsCall(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: language
        ))

        guard let stub = detailsStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let season):
            return season
        case .failure(let error):
            throw error
        }
    }

    func details(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        appending: TVSeasonAppendOption,
        language: String?
    ) async throws(TMDbError) -> TVSeasonDetailsResponse {
        fatalError("Not implemented")
    }

    func images(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeasonImageFilter?
    ) async throws(TMDbError) -> ImageCollection {
        fatalError("Not implemented")
    }

    func videos(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeasonVideoFilter?
    ) async throws(TMDbError) -> VideoCollection {
        fatalError("Not implemented")
    }

    func credits(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws(TMDbError) -> ShowCredits {
        fatalError("Not implemented")
    }

    func aggregateCredits(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws(TMDbError) -> TVSeasonAggregateCredits {
        fatalError("Not implemented")
    }

    func watchProviders(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> [ShowWatchProvidersByCountry] {
        fatalError("Not implemented")
    }

    func translations(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> TranslationCollection<TVSeasonTranslationData> {
        fatalError("Not implemented")
    }

    func externalLinks(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> TVSeasonExternalLinksCollection {
        fatalError("Not implemented")
    }

    func changes(
        forSeason seasonID: TVSeason.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        fatalError("Not implemented")
    }

    func accountStates(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws(TMDbError) -> AccountStates {
        fatalError("Not implemented")
    }

}
