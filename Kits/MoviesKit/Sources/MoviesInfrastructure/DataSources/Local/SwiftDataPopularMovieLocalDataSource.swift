//
//  SwiftDataPopularMovieLocalDataSource.swift
//  MoviesKit
//
//  Created by Adam Young on 03/12/2025.
//

import DataPersistenceInfrastructure
import Foundation
import MoviesDomain
import OSLog
import SwiftData

@ModelActor
actor SwiftDataPopularMovieLocalDataSource: PopularMovieLocalDataSource, SwiftDataFetchStreaming,
    Sendable
{

    private static let logger = Logger(
        subsystem: "MoviesKit",
        category: "SwiftDataPopularMovieLocalDataSource"
    )

    private var ttl: TimeInterval = 60 * 60 * 24  // 1 day

    func popular(page: Int) async throws(PopularMovieLocalDataSourceError) -> [MoviePreview]? {
        let descriptor = FetchDescriptor<PopularMovieItemEntity>(
            predicate: #Predicate { $0.page == page },
            sortBy: [SortDescriptor(\.sortIndex)]
        )

        let entities: [PopularMovieItemEntity]
        do {
            entities = try modelContext.fetch(descriptor)
        } catch let error {
            throw .persistence(error)
        }

        guard !entities.isEmpty else {
            Self.logger.trace("SwiftData MISS: PopularMovies(page: \(page, privacy: .public))")
            return nil
        }

        let anyExpired = entities.contains { entity in
            entity.isExpired(ttl: ttl) || entity.movie?.isExpired(ttl: ttl) == true
        }

        if anyExpired {
            Self.logger.trace(
                "SwiftData EXPIRED: PopularMovies(page: \(page, privacy: .public)) — deleting")

            let deleteDescriptor = FetchDescriptor<PopularMovieItemEntity>(
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

        Self.logger.trace("SwiftData HIT: PopularMovies(page: \(page, privacy: .public))")

        let mapper = MoviePreviewMapper()
        return entities.compactMap {
            mapper.compactMap($0.movie)
        }
    }

    func popularStream() -> AsyncThrowingStream<[MoviePreview]?, Error> {
        let descriptor = FetchDescriptor<PopularMovieItemEntity>(
            sortBy: [SortDescriptor(\.page), SortDescriptor(\.sortIndex)]
        )
        let stream = stream(for: descriptor) { entities -> [MoviePreview]? in
            guard !entities.isEmpty else {
                return nil
            }

            let mapper = MoviePreviewMapper()
            return entities.compactMap {
                mapper.compactMap($0.movie)
            }
        }

        return stream
    }

    func currentPopularStreamPage() async throws(PopularMovieLocalDataSourceError) -> Int? {
        var descriptor = FetchDescriptor<PopularMovieItemEntity>(
            sortBy: [SortDescriptor(\.page, order: .reverse)]
        )
        descriptor.fetchLimit = 1

        let entity: PopularMovieItemEntity?
        do {
            entity = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        return entity?.page
    }

    func setPopular(
        _ moviePreviews: [MoviePreview],
        page: Int
    ) async throws(PopularMovieLocalDataSourceError) {
        let deleteDescriptor = FetchDescriptor<PopularMovieItemEntity>(
            predicate: #Predicate { $0.page >= page }
        )
        do {
            let entitiesToDelete = try modelContext.fetch(deleteDescriptor)
            entitiesToDelete.forEach(modelContext.delete)
        } catch let error {
            throw .persistence(error)
        }

        for (index, preview) in moviePreviews.enumerated() {
            let id = preview.id
            let descriptor = FetchDescriptor<MoviePreviewEntity>(
                predicate: #Predicate { $0.movieID == id })
            let mapper = MoviePreviewMapper()

            let existing: MoviePreviewEntity?
            do { existing = try modelContext.fetch(descriptor).first } catch let error {
                throw .persistence(error)
            }

            let previewEntity: MoviePreviewEntity
            if let existing {
                mapper.map(preview, to: existing)
                previewEntity = existing
            } else {
                let entity = mapper.map(preview)
                modelContext.insert(entity)
                previewEntity = entity
            }

            let itemEntity = PopularMovieItemEntity(
                sortIndex: index,
                page: page,
                movie: previewEntity
            )
            modelContext.insert(itemEntity)
        }

        do { try modelContext.save() } catch let error { throw .unknown(error) }
    }

}
