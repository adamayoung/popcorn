//
//  SwiftDataTVSeriesAggregateCreditsLocalDataSource.swift
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
actor SwiftDataTVSeriesAggregateCreditsLocalDataSource: TVSeriesAggregateCreditsLocalDataSource,
SwiftDataFetchStreaming {

    private static let logger = Logger.tvSeriesInfrastructure

    private var ttl: TimeInterval = 60 * 60 * 24 // 1 day

    func aggregateCredits(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesAggregateCreditsLocalDataSourceError) -> AggregateCredits? {
        let entity: TVSeriesAggregateCreditsEntity?
        var descriptor = FetchDescriptor<TVSeriesAggregateCreditsEntity>(
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
                "SwiftData MISS: AggregateCredits(tv-series-id: \(tvSeriesID, privacy: .public))"
            )
            return nil
        }

        guard !entity.isExpired(ttl: ttl) else {
            Self.logger.debug(
                "SwiftData EXPIRED: AggregateCredits(tv-series-id: \(tvSeriesID, privacy: .public)) - deleting"
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
            "SwiftData HIT: AggregateCredits(tv-series-id: \(tvSeriesID, privacy: .public))"
        )

        let mapper = AggregateCreditsEntityMapper()
        return mapper.map(entity)
    }

    func setAggregateCredits(
        _ aggregateCredits: AggregateCredits,
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesAggregateCreditsLocalDataSourceError) {
        let descriptor = FetchDescriptor<TVSeriesAggregateCreditsEntity>(
            predicate: #Predicate { $0.tvSeriesID == tvSeriesID }
        )
        let existing: TVSeriesAggregateCreditsEntity?

        do {
            existing = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        let mapper = AggregateCreditsEntityMapper()

        if let existing {
            existing.cast.forEach { modelContext.delete($0) }
            existing.crew.forEach { modelContext.delete($0) }

            mapper.map(aggregateCredits, tvSeriesID: tvSeriesID, to: existing)
        } else {
            let entity = mapper.map(aggregateCredits, tvSeriesID: tvSeriesID)
            modelContext.insert(entity)
        }

        do {
            try modelContext.save()
        } catch let error {
            throw .persistence(error)
        }
    }

}
