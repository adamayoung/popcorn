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
    ) async throws -> TVSeason {
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
    ) async throws -> TVSeasonDetailsResponse {
        fatalError("Not implemented")
    }

    func images(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeasonImageFilter?
    ) async throws -> ImageCollection {
        fatalError("Not implemented")
    }

    func videos(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeasonVideoFilter?
    ) async throws -> VideoCollection {
        fatalError("Not implemented")
    }

    func credits(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws -> ShowCredits {
        fatalError("Not implemented")
    }

    func aggregateCredits(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws -> TVSeasonAggregateCredits {
        fatalError("Not implemented")
    }

    func watchProviders(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> [ShowWatchProvidersByCountry] {
        fatalError("Not implemented")
    }

    func translations(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> TranslationCollection<TVSeasonTranslationData> {
        fatalError("Not implemented")
    }

    func externalLinks(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> TVSeasonExternalLinksCollection {
        fatalError("Not implemented")
    }

    func changes(
        forSeason seasonID: TVSeason.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection {
        fatalError("Not implemented")
    }

    func accountStates(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws -> AccountStates {
        fatalError("Not implemented")
    }

}
