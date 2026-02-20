//
//  SwiftDataTVSeasonLocalDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import OSLog
import SwiftData
import TVSeriesDomain

@ModelActor
actor SwiftDataTVSeasonLocalDataSource: TVSeasonLocalDataSource {

    private static let logger = Logger.tvSeriesInfrastructure

    private let ttl: TimeInterval = 60 * 60 * 24 // 1 day

    func season(
        _ seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVSeasonLocalDataSourceError) -> TVSeason? {
        let key = TVSeasonEpisodesEntity.makeCompositeKey(
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber
        )

        let entity: TVSeasonEpisodesEntity?
        var descriptor = FetchDescriptor<TVSeasonEpisodesEntity>(
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
                "SwiftData MISS: TVSeason(key: \(key, privacy: .public))"
            )
            return nil
        }

        guard !entity.isExpired(ttl: ttl) else {
            Self.logger.trace(
                "SwiftData EXPIRED: TVSeason(key: \(key, privacy: .public)) — deleting"
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
            "SwiftData HIT: TVSeason(key: \(key, privacy: .public))"
        )

        let mapper = TVSeasonEpisodesEntityMapper()
        return mapper.map(entity)
    }

    func setSeason(
        _ season: TVSeason,
        inTVSeries tvSeriesID: Int
    ) async throws(TVSeasonLocalDataSourceError) {
        let key = TVSeasonEpisodesEntity.makeCompositeKey(
            tvSeriesID: tvSeriesID,
            seasonNumber: season.seasonNumber
        )

        var descriptor = FetchDescriptor<TVSeasonEpisodesEntity>(
            predicate: #Predicate { $0.compositeKey == key }
        )
        descriptor.fetchLimit = 1
        let existing: TVSeasonEpisodesEntity?
        do {
            existing = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        let mapper = TVSeasonEpisodesEntityMapper()
        if let existing {
            for episode in existing.episodes {
                modelContext.delete(episode)
            }
            mapper.map(season, to: existing)
        } else {
            let entity = mapper.map(season, tvSeriesID: tvSeriesID)
            modelContext.insert(entity)
        }

        do {
            try modelContext.save()
        } catch let error {
            throw .persistence(error)
        }
    }

}
