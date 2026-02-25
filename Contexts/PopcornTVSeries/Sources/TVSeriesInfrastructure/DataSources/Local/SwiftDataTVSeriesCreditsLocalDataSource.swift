//
//  SwiftDataTVSeriesCreditsLocalDataSource.swift
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
actor SwiftDataTVSeriesCreditsLocalDataSource: TVSeriesCreditsLocalDataSource,
SwiftDataFetchStreaming {

    private static let logger = Logger.tvSeriesInfrastructure

    private var ttl: TimeInterval = 60 * 60 * 24 // 1 day

    func credits(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesCreditsLocalDataSourceError) -> Credits? {
        let entity: TVSeriesCreditsEntity?
        var descriptor = FetchDescriptor<TVSeriesCreditsEntity>(
            predicate: #Predicate { $0.tvSeriesID == tvSeriesID }
        )
        descriptor.fetchLimit = 1

        do {
            entity = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        guard let entity else {
            Self.logger.debug(
                "SwiftData MISS: Credits(tv-series-id: \(tvSeriesID, privacy: .public))"
            )
            return nil
        }

        guard !entity.isExpired(ttl: ttl) else {
            Self.logger.debug(
                "SwiftData EXPIRED: Credits(tv-series-id: \(tvSeriesID, privacy: .public)) - deleting"
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
            "SwiftData HIT: Credits(tv-series-id: \(tvSeriesID, privacy: .public))"
        )

        let mapper = CreditsEntityMapper()
        return mapper.map(entity)
    }

    func setCredits(
        _ credits: Credits,
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesCreditsLocalDataSourceError) {
        let descriptor = FetchDescriptor<TVSeriesCreditsEntity>(
            predicate: #Predicate { $0.tvSeriesID == tvSeriesID }
        )
        let existing: TVSeriesCreditsEntity?

        do {
            existing = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        let mapper = CreditsEntityMapper()

        if let existing {
            // Delete existing cast/crew first (cascade only triggers on parent delete)
            existing.cast.forEach { modelContext.delete($0) }
            existing.crew.forEach { modelContext.delete($0) }

            mapper.map(credits, tvSeriesID: tvSeriesID, to: existing)
        } else {
            let entity = mapper.map(credits, tvSeriesID: tvSeriesID)
            modelContext.insert(entity)
        }

        do {
            try modelContext.save()
        } catch let error {
            throw .persistence(error)
        }
    }

}
