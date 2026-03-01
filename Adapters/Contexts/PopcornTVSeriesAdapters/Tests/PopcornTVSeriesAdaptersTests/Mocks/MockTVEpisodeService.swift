//
//  MockTVEpisodeService.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

final class MockTVEpisodeService: TVEpisodeService, @unchecked Sendable {

    struct DetailsCall: Equatable {
        let episodeNumber: Int
        let seasonNumber: Int
        let tvSeriesID: Int
        let language: String?
    }

    var detailsCallCount = 0
    var detailsCalledWith: [DetailsCall] = []
    var detailsStub: Result<TVEpisode, TMDbError>?

    func details(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws -> TVEpisode {
        detailsCallCount += 1
        detailsCalledWith.append(DetailsCall(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: language
        ))

        guard let stub = detailsStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let episode):
            return episode
        case .failure(let error):
            throw error
        }
    }

    func details(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        appending: TVEpisodeAppendOption,
        language: String?
    ) async throws -> TVEpisodeDetailsResponse {
        throw TMDbError.unknown
    }

    struct CreditsCall: Equatable {
        let episodeNumber: Int
        let seasonNumber: Int
        let tvSeriesID: Int
        let language: String?
    }

    var creditsCallCount = 0
    var creditsCalledWith: [CreditsCall] = []
    var creditsStub: Result<ShowCredits, TMDbError>?

    func credits(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws -> ShowCredits {
        creditsCallCount += 1
        creditsCalledWith.append(CreditsCall(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: language
        ))

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

    func images(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVEpisodeImageFilter?
    ) async throws -> TVEpisodeImageCollection {
        throw TMDbError.unknown
    }

    func videos(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVEpisodeVideoFilter?
    ) async throws -> VideoCollection {
        throw TMDbError.unknown
    }

    func accountStates(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws -> AccountStates {
        throw TMDbError.unknown
    }

    func addRating(
        _ rating: Double,
        toEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws {
        throw TMDbError.unknown
    }

    func deleteRating(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws {
        throw TMDbError.unknown
    }

    func externalLinks(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> TVEpisodeExternalLinksCollection {
        throw TMDbError.unknown
    }

    func translations(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> TranslationCollection<TVEpisodeTranslationData> {
        throw TMDbError.unknown
    }

    func changes(
        forEpisode episodeID: Int,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection {
        throw TMDbError.unknown
    }

}
