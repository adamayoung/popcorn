//
//  SwiftDataTVEpisodeLocalDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import OSLog
import SwiftData
import TVSeriesDomain

@ModelActor
actor SwiftDataTVEpisodeLocalDataSource: TVEpisodeLocalDataSource {

    private static let logger = Logger.tvSeriesInfrastructure

    private let ttl: TimeInterval = 60 * 60 * 24 // 1 day

    func episode(
        _ episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVEpisodeLocalDataSourceError) -> TVEpisode? {
        let key = TVEpisodeDetailsCacheEntity.makeCompositeKey(
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber
        )

        let entity: TVEpisodeDetailsCacheEntity?
        var descriptor = FetchDescriptor<TVEpisodeDetailsCacheEntity>(
            predicate: #Predicate { $0.compositeKey == key }
        )
        descriptor.fetchLimit = 1
        do {
            entity = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        guard let entity else {
            Self.logger.trace(
                "SwiftData MISS: TVEpisode(key: \(key, privacy: .public))"
            )
            return nil
        }

        guard !entity.isExpired(ttl: ttl) else {
            Self.logger.trace(
                "SwiftData EXPIRED: TVEpisode(key: \(key, privacy: .public)) — deleting"
            )
            modelContext.delete(entity)
            do {
                try modelContext.save()
            } catch let error {
                throw .persistence(error)
            }
            return nil
        }

        Self.logger.trace(
            "SwiftData HIT: TVEpisode(key: \(key, privacy: .public))"
        )

        let mapper = TVEpisodeDetailsCacheEntityMapper()
        return mapper.map(entity)
    }

    func setEpisode(
        _ episode: TVEpisode,
        inTVSeries tvSeriesID: Int
    ) async throws(TVEpisodeLocalDataSourceError) {
        let key = TVEpisodeDetailsCacheEntity.makeCompositeKey(
            tvSeriesID: tvSeriesID,
            seasonNumber: episode.seasonNumber,
            episodeNumber: episode.episodeNumber
        )

        var descriptor = FetchDescriptor<TVEpisodeDetailsCacheEntity>(
            predicate: #Predicate { $0.compositeKey == key }
        )
        descriptor.fetchLimit = 1
        let existing: TVEpisodeDetailsCacheEntity?
        do {
            existing = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        let mapper = TVEpisodeDetailsCacheEntityMapper()
        if let existing {
            mapper.map(episode, to: existing)
        } else {
            let entity = mapper.map(episode, tvSeriesID: tvSeriesID)
            modelContext.insert(entity)
        }

        do {
            try modelContext.save()
        } catch let error {
            throw .persistence(error)
        }
    }

}
