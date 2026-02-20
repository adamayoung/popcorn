//
//  SwiftDataTVSeriesLocalDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import OSLog
import SwiftData
import TVSeriesDomain

@ModelActor
actor SwiftDataTVSeriesLocalDataSource: TVSeriesLocalDataSource {

    private static let logger = Logger.tvSeriesInfrastructure

    private let ttl: TimeInterval = 60 * 60 * 24 // 1 day

    func tvSeries(
        withID id: Int
    ) async throws(TVSeriesLocalDataSourceError) -> TVSeries? {
        let entity: TVSeriesEntity?
        var descriptor = FetchDescriptor<TVSeriesEntity>(
            predicate: #Predicate { $0.tvSeriesID == id }
        )
        descriptor.fetchLimit = 1
        do {
            entity = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        guard let entity else {
            Self.logger.trace(
                "SwiftData MISS: TVSeries(id: \(id, privacy: .public))"
            )
            return nil
        }

        guard !entity.isExpired(ttl: ttl) else {
            Self.logger.trace(
                "SwiftData EXPIRED: TVSeries(id: \(id, privacy: .public)) — deleting"
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
            "SwiftData HIT: TVSeries(id: \(id, privacy: .public))"
        )

        let mapper = TVSeriesEntityMapper()
        return mapper.map(entity)
    }

    func setTVSeries(
        _ tvSeries: TVSeries
    ) async throws(TVSeriesLocalDataSourceError) {
        let id = tvSeries.id
        let descriptor = FetchDescriptor<TVSeriesEntity>(
            predicate: #Predicate { $0.tvSeriesID == id }
        )
        let existing: TVSeriesEntity?
        do {
            existing = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        let mapper = TVSeriesEntityMapper()
        if let existing {
            mapper.map(tvSeries, to: existing)
        } else {
            let entity = mapper.map(tvSeries)
            modelContext.insert(entity)
        }

        do {
            try modelContext.save()
        } catch let error {
            throw .persistence(error)
        }
    }

    func images(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesLocalDataSourceError) -> ImageCollection? {
        let entity: TVSeriesImageCollectionEntity?
        var descriptor = FetchDescriptor<TVSeriesImageCollectionEntity>(
            predicate: #Predicate { $0.tvSeriesID == tvSeriesID }
        )
        descriptor.fetchLimit = 1

        do {
            entity = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        guard let entity else {
            Self.logger.trace(
                "SwiftData MISS: ImageCollection(tv-series-id: \(tvSeriesID, privacy: .public))"
            )
            return nil
        }

        guard !entity.isExpired(ttl: ttl) else {
            Self.logger.trace(
                "SwiftData EXPIRED: ImageCollection(tv-series-id: \(tvSeriesID, privacy: .public)) — deleting"
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
            "SwiftData HIT: ImageCollection(tv-series-id: \(tvSeriesID, privacy: .public))"
        )

        let mapper = TVSeriesImageCollectionEntityMapper()
        return mapper.map(entity)
    }

    func setImages(
        _ imageCollection: ImageCollection,
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesLocalDataSourceError) {
        let descriptor = FetchDescriptor<TVSeriesImageCollectionEntity>(
            predicate: #Predicate { $0.tvSeriesID == tvSeriesID }
        )
        let existing: TVSeriesImageCollectionEntity?
        do {
            existing = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        let mapper = TVSeriesImageCollectionEntityMapper()
        if let existing {
            mapper.map(imageCollection, to: existing)
        } else {
            let entity = mapper.map(imageCollection)
            modelContext.insert(entity)
        }

        do {
            try modelContext.save()
        } catch let error {
            throw .persistence(error)
        }
    }

}
