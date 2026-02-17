//
//  SwiftDataSimilarMovieLocalDataSource.swift
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
actor SwiftDataSimilarMovieLocalDataSource: SimilarMovieLocalDataSource, SwiftDataFetchStreaming {

    private static let logger = Logger.moviesInfrastructure

    private var ttl: TimeInterval = 60 * 60 * 24 // 1 day

    func similar(
        toMovie movieID: Int,
        page: Int
    ) async throws(SimilarMovieLocalDataSourceError) -> [MoviePreview]? {
        let descriptor = FetchDescriptor<MoviesSimilarMovieItemEntity>(
            predicate: #Predicate { $0.movieID == movieID && $0.page == page },
            sortBy: [SortDescriptor(\.sortIndex)]
        )

        let entities: [MoviesSimilarMovieItemEntity]
        do {
            entities = try modelContext.fetch(descriptor)
        } catch let error {
            throw .persistence(error)
        }

        guard !entities.isEmpty else {
            Self.logger.trace("SwiftData MISS: SimilarMovies(page: \(page, privacy: .public))")
            return nil
        }

        let anyExpired = entities.contains { entity in
            entity.isExpired(ttl: ttl) || entity.movie?.isExpired(ttl: ttl) == true
        }

        if anyExpired {
            Self.logger.trace(
                "SwiftData EXPIRED: SimilarMovies(page: \(page, privacy: .public)) — deleting"
            )
            let deleteDescriptor = FetchDescriptor<MoviesSimilarMovieItemEntity>(
                predicate: #Predicate { $0.page >= page }
            )
            do {
                let entitiesToDelete = try modelContext.fetch(deleteDescriptor)
                entitiesToDelete.forEach(modelContext.delete)
            } catch let error {
                throw .persistence(error)
            }

            return nil
        }

        Self.logger.trace("SwiftData HIT: SimilarMovies(page: \(page, privacy: .public))")

        let mapper = MoviePreviewMapper()
        return entities.compactMap {
            mapper.compactMap($0.movie)
        }
    }

    func similarStream(
        toMovie movieID: Int,
        limit: Int? = nil
    ) -> AsyncThrowingStream<[MoviePreview]?, Error> {
        var descriptor = FetchDescriptor<MoviesSimilarMovieItemEntity>(
            predicate: #Predicate { $0.movieID == movieID },
            sortBy: [SortDescriptor(\.page), SortDescriptor(\.sortIndex)]
        )
        descriptor.fetchLimit = limit
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

    func currentSimilarStreamPage(
        forMovie movieID: Int
    ) async throws(SimilarMovieLocalDataSourceError) -> Int? {
        var descriptor = FetchDescriptor<MoviesSimilarMovieItemEntity>(
            predicate: #Predicate { $0.movieID == movieID },
            sortBy: [SortDescriptor(\.page, order: .reverse)]
        )
        descriptor.fetchLimit = 1

        let entity: MoviesSimilarMovieItemEntity?
        do {
            entity = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        return entity?.page
    }

    func setSimilar(
        _ moviePreviews: [MoviePreview],
        toMovie movieID: Int,
        page: Int
    ) async throws(SimilarMovieLocalDataSourceError) {
        let deleteDescriptor = FetchDescriptor<MoviesSimilarMovieItemEntity>(
            predicate: #Predicate { $0.movieID == movieID && $0.page >= page }
        )
        do {
            let entitiesToDelete = try modelContext.fetch(deleteDescriptor)
            entitiesToDelete.forEach(modelContext.delete)
            try modelContext.save()
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

            let itemEntity = MoviesSimilarMovieItemEntity(
                movieID: movieID,
                sortIndex: index,
                page: page,
                movie: previewEntity
            )
            modelContext.insert(itemEntity)
        }

        do { try modelContext.save() } catch let error { throw .persistence(error) }
    }

}
