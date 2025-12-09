//
//  SwiftDataDiscoverTVSeriesLocalDataSource.swift
//  PopcornDiscover
//
//  Created by Adam Young on 09/12/2025.
//

import DataPersistenceInfrastructure
import DiscoverDomain
import Foundation
import OSLog
import SwiftData

@ModelActor
actor SwiftDataDiscoverTVSeriesLocalDataSource: DiscoverTVSeriesLocalDataSource,
    SwiftDataFetchStreaming, Sendable
{

    private static let logger = Logger(
        subsystem: "PopcornDiscover",
        category: "SwiftDataDiscoverTVSeriesLocalDataSource"
    )

    private var ttl: TimeInterval = 60 * 60 * 24  // 1 day

    func tvSeries(
        filter: TVSeriesFilter?,
        page: Int
    ) async throws(DiscoverTVSeriesLocalDataSourceError) -> [TVSeriesPreview]? {
        let filterKey = filter?.description
        let descriptor = FetchDescriptor<DiscoverTVSeriesItemEntity>(
            predicate: #Predicate { $0.page == page && $0.filterKey == filterKey },
            sortBy: [SortDescriptor(\.sortIndex)]
        )

        let entities: [DiscoverTVSeriesItemEntity]
        do {
            entities = try modelContext.fetch(descriptor)
        } catch let error {
            throw .persistence(error)
        }

        guard !entities.isEmpty else {
            Self.logger.trace(
                "SwiftData MISS: DiscoverTVSeries(filter: \(filterKey ?? "nil", privacy: .public), page: \(page, privacy: .public))"
            )
            return nil
        }

        let anyExpired = entities.contains { entity in
            entity.isExpired(ttl: ttl) || entity.tvSeries?.isExpired(ttl: ttl) == true
        }

        if anyExpired {
            Self.logger.trace(
                "SwiftData EXPIRED: DiscoverTVSeries(filter: \(filterKey ?? "nil", privacy: .public), page: \(page, privacy: .public)) — deleting"
            )

            let deleteDescriptor = FetchDescriptor<DiscoverMovieItemEntity>(
                predicate: #Predicate { $0.page >= page }
            )
            do {
                let entitiesToDelete = try modelContext.fetch(deleteDescriptor)
                entitiesToDelete.forEach(modelContext.delete)
                try modelContext.save()
            } catch let error {
                throw .persistence(error)
            }

            return nil
        }

        Self.logger.trace(
            "SwiftData HIT: DiscoverMovies(filter: \(filterKey ?? "nil", privacy: .public), page: \(page, privacy: .public))"
        )

        let mapper = TVSeriesPreviewMapper()
        return entities.compactMap {
            mapper.compactMap($0.tvSeries)
        }
    }

    func tvSeriesStream(
        filter: TVSeriesFilter?
    ) async -> AsyncThrowingStream<[TVSeriesPreview]?, any Error> {
        let filterKey = filter?.description
        let descriptor = FetchDescriptor<DiscoverTVSeriesItemEntity>(
            predicate: #Predicate { $0.filterKey == filterKey },
            sortBy: [SortDescriptor(\.page), SortDescriptor(\.sortIndex)]
        )
        let stream = stream(for: descriptor) { entities -> [TVSeriesPreview]? in
            guard !entities.isEmpty else {
                return nil
            }

            let mapper = TVSeriesPreviewMapper()
            return entities.compactMap {
                mapper.compactMap($0.tvSeries)
            }
        }

        return stream
    }

    func currentTVSeriesStreamPage(
        filter: TVSeriesFilter?
    ) async throws(DiscoverTVSeriesLocalDataSourceError) -> Int? {
        let filterKey = filter?.description
        var descriptor = FetchDescriptor<DiscoverTVSeriesItemEntity>(
            predicate: #Predicate { $0.filterKey == filterKey },
            sortBy: [SortDescriptor(\.page, order: .reverse)]
        )
        descriptor.fetchLimit = 1

        let entity: DiscoverTVSeriesItemEntity?
        do {
            entity = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        return entity?.page
    }

    func setTVSeries(
        _ tvSeriesPreviews: [TVSeriesPreview],
        filter: TVSeriesFilter?,
        page: Int
    ) async throws(DiscoverTVSeriesLocalDataSourceError) {
        let filterKey = filter?.description
        let deleteDescriptor = FetchDescriptor<DiscoverTVSeriesItemEntity>(
            predicate: #Predicate { $0.page >= page && $0.filterKey == filterKey }
        )
        do {
            let entitiesToDelete = try modelContext.fetch(deleteDescriptor)
            entitiesToDelete.forEach(modelContext.delete)
            try modelContext.save()
        } catch let error {
            throw .persistence(error)
        }

        for (index, preview) in tvSeriesPreviews.enumerated() {
            let id = preview.id
            let descriptor = FetchDescriptor<DiscoverTVSeriesPreviewEntity>(
                predicate: #Predicate { $0.tvSeriesID == id })
            let mapper = TVSeriesPreviewMapper()
            let existing: DiscoverTVSeriesPreviewEntity?
            do { existing = try modelContext.fetch(descriptor).first } catch let error {
                throw .persistence(error)
            }

            let previewEntity: DiscoverTVSeriesPreviewEntity
            if let existing {
                mapper.map(preview, to: existing)
                previewEntity = existing
            } else {
                let entity = mapper.map(preview)
                modelContext.insert(entity)
                previewEntity = entity
            }

            let itemEntity = DiscoverTVSeriesItemEntity(
                sortIndex: index,
                page: page,
                filterKey: filterKey,
                tvSeries: previewEntity
            )
            modelContext.insert(itemEntity)
        }

        do { try modelContext.save() } catch let error { throw .persistence(error) }
    }

}
