//
//  SwiftDataPopularMovieLocalDataSource.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import DataPersistenceInfrastructure
import Foundation
import MoviesDomain
import OSLog
import SwiftData

@ModelActor
actor SwiftDataPopularMovieLocalDataSource: PopularMovieLocalDataSource, SwiftDataFetchStreaming {

    private static let logger = Logger.moviesInfrastructure

    private var ttl: TimeInterval = 60 * 60 * 24 // 1 day

    func popular(page: Int) async throws(PopularMovieLocalDataSourceError) -> [MoviePreview]? {
        let descriptor = FetchDescriptor<MoviesPopularMovieItemEntity>(
            predicate: #Predicate { $0.page == page },
            sortBy: [SortDescriptor(\.sortIndex)]
        )

        let entities: [MoviesPopularMovieItemEntity]
        do {
            entities = try modelContext.fetch(descriptor)
        } catch let error {
            throw .persistence(error)
        }

        guard !entities.isEmpty else {
            Self.logger.debug("SwiftData MISS: PopularMovies(page: \(page, privacy: .public))")
            return nil
        }

        let anyExpired = entities.contains { entity in
            entity.isExpired(ttl: ttl) || entity.movie?.isExpired(ttl: ttl) == true
        }

        if anyExpired {
            Self.logger.debug(
                "SwiftData EXPIRED: PopularMovies(page: \(page, privacy: .public)) — deleting"
            )

            let deleteDescriptor = FetchDescriptor<MoviesPopularMovieItemEntity>(
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

        Self.logger.debug("SwiftData HIT: PopularMovies(page: \(page, privacy: .public))")

        let mapper = MoviePreviewMapper()
        return entities.compactMap {
            mapper.compactMap($0.movie)
        }
    }

    func popularStream() -> AsyncThrowingStream<[MoviePreview]?, Error> {
        let descriptor = FetchDescriptor<MoviesPopularMovieItemEntity>(
            sortBy: [SortDescriptor(\.page), SortDescriptor(\.sortIndex)]
        )
        return stream(for: descriptor) { entities -> [MoviePreview]? in
            guard !entities.isEmpty else {
                return nil
            }

            let mapper = MoviePreviewMapper()
            return entities.compactMap {
                mapper.compactMap($0.movie)
            }
        }
    }

    func currentPopularStreamPage() async throws(PopularMovieLocalDataSourceError) -> Int? {
        var descriptor = FetchDescriptor<MoviesPopularMovieItemEntity>(
            sortBy: [SortDescriptor(\.page, order: .reverse)]
        )
        descriptor.fetchLimit = 1

        let entity: MoviesPopularMovieItemEntity?
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
        let deleteDescriptor = FetchDescriptor<MoviesPopularMovieItemEntity>(
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
            let descriptor = FetchDescriptor<MoviesMoviePreviewEntity>(
                predicate: #Predicate { $0.movieID == id }
            )
            let mapper = MoviePreviewMapper()

            let existing: MoviesMoviePreviewEntity?
            do { existing = try modelContext.fetch(descriptor).first } catch let error {
                throw .persistence(error)
            }

            let previewEntity: MoviesMoviePreviewEntity
            if let existing {
                mapper.map(preview, to: existing)
                previewEntity = existing
            } else {
                let entity = mapper.map(preview)
                modelContext.insert(entity)
                previewEntity = entity
            }

            let itemEntity = MoviesPopularMovieItemEntity(
                sortIndex: index,
                page: page,
                movie: previewEntity
            )
            modelContext.insert(itemEntity)
        }

        do { try modelContext.save() } catch let error { throw .unknown(error) }
    }

}
