//
//  SwiftDataTVEpisodeCreditsLocalDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import DataPersistenceInfrastructure
import Foundation
import OSLog
import SwiftData
import TVSeriesDomain

@ModelActor
actor SwiftDataTVEpisodeCreditsLocalDataSource: TVEpisodeCreditsLocalDataSource,
SwiftDataFetchStreaming {

    private static let logger = Logger.tvSeriesInfrastructure

    private var ttl: TimeInterval = 60 * 60 * 24 // 1 day

    func credits(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVEpisodeCreditsLocalDataSourceError) -> Credits? {
        let compositeKey = "\(tvSeriesID)-\(seasonNumber)-\(episodeNumber)"
        let entity: TVEpisodeCreditsEntity?
        var descriptor = FetchDescriptor<TVEpisodeCreditsEntity>(
            predicate: #Predicate { $0.compositeKey == compositeKey }
        )
        descriptor.fetchLimit = 1

        do {
            entity = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        guard let entity else {
            Self.logger.debug(
                "SwiftData MISS: EpisodeCredits(tv-series-id: \(tvSeriesID, privacy: .public), S\(seasonNumber)E\(episodeNumber))"
            )
            return nil
        }

        guard !entity.isExpired(ttl: ttl) else {
            Self.logger.debug(
                "SwiftData EXPIRED: EpisodeCredits(tv-series-id: \(tvSeriesID, privacy: .public), S\(seasonNumber)E\(episodeNumber)) - deleting"
            )
            modelContext.delete(entity)
            do {
                try modelContext.save()
            } catch let error {
                throw .persistence(error)
            }
            return nil
        }

        Self.logger.debug(
            "SwiftData HIT: EpisodeCredits(tv-series-id: \(tvSeriesID, privacy: .public), S\(seasonNumber)E\(episodeNumber))"
        )

        let mapper = TVEpisodeCreditsEntityMapper()
        return mapper.map(entity)
    }

    func setCredits(
        _ credits: Credits,
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVEpisodeCreditsLocalDataSourceError) {
        let compositeKey = "\(tvSeriesID)-\(seasonNumber)-\(episodeNumber)"
        let descriptor = FetchDescriptor<TVEpisodeCreditsEntity>(
            predicate: #Predicate { $0.compositeKey == compositeKey }
        )
        let existing: TVEpisodeCreditsEntity?

        do {
            existing = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        let mapper = TVEpisodeCreditsEntityMapper()

        if let existing {
            existing.cast.forEach { modelContext.delete($0) }
            existing.crew.forEach { modelContext.delete($0) }

            do {
                try modelContext.save()
            } catch let error {
                throw .persistence(error)
            }

            mapper.map(
                credits,
                tvSeriesID: tvSeriesID,
                seasonNumber: seasonNumber,
                episodeNumber: episodeNumber,
                to: existing
            )
        } else {
            let entity = mapper.map(
                credits,
                tvSeriesID: tvSeriesID,
                seasonNumber: seasonNumber,
                episodeNumber: episodeNumber
            )
            modelContext.insert(entity)
        }

        do {
            try modelContext.save()
        } catch let error {
            throw .persistence(error)
        }
    }

}
