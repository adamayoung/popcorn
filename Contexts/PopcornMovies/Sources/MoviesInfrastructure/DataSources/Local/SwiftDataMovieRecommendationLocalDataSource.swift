//
//  SwiftDataMovieRecommendationLocalDataSource.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import DataPersistenceInfrastructure
import Foundation
import MoviesDomain
import OSLog
import SwiftData

// swiftlint:disable type_name
@ModelActor
actor SwiftDataMovieRecommendationLocalDataSource: MovieRecommendationLocalDataSource, SwiftDataFetchStreaming {
    // swiftlint:enable type_name

    private static let logger = Logger.moviesInfrastructure

    private var ttl: TimeInterval = 60 * 60 * 24 // 1 day

    func recommendations(
        forMovie movieID: Int,
        page: Int
    ) async throws(MovieRecommendationLocalDataSourceError) -> [MoviePreview]? {
        let descriptor = FetchDescriptor<MoviesRecommendationMovieItemEntity>(
            predicate: #Predicate { $0.movieID == movieID && $0.page == page },
            sortBy: [SortDescriptor(\.sortIndex)]
        )

        let entities: [MoviesRecommendationMovieItemEntity]
        do {
            entities = try modelContext.fetch(descriptor)
        } catch let error {
            throw .persistence(error)
        }

        guard !entities.isEmpty else {
            Self.logger.trace(
                "SwiftData MISS: MovieRecommendations(movieID: \(movieID, privacy: .public), page: \(page, privacy: .public))"
            )
            return nil
        }

        let anyExpired = entities.contains { entity in
            entity.isExpired(ttl: ttl) || entity.movie?.isExpired(ttl: ttl) == true
        }

        if anyExpired {
            Self.logger.trace(
                "SwiftData EXPIRED: MovieRecommendations(movieID: \(movieID, privacy: .public), page: \(page, privacy: .public)) — deleting"
            )
            let deleteDescriptor = FetchDescriptor<MoviesRecommendationMovieItemEntity>(
                predicate: #Predicate { $0.page >= page && $0.movieID == movieID }
            )
            do {
                let entitiesToDelete = try modelContext.fetch(deleteDescriptor)
                entitiesToDelete.forEach(modelContext.delete)
            } catch let error {
                throw .persistence(error)
            }

            return nil
        }

        Self.logger.trace(
            "SwiftData HIT: MovieRecommendations(movieID: \(movieID, privacy: .public), page: \(page, privacy: .public))"
        )

        let mapper = MoviePreviewMapper()
        return entities.compactMap {
            mapper.compactMap($0.movie)
        }
    }

    func setRecommendations(
        _ moviePreviews: [MoviePreview],
        forMovie movieID: Int,
        page: Int
    ) async throws(MovieRecommendationLocalDataSourceError) {
        let deleteDescriptor = FetchDescriptor<MoviesRecommendationMovieItemEntity>(
            predicate: #Predicate { $0.page >= page && $0.movieID == movieID }
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
                predicate: #Predicate { $0.movieID == id })
            let mapper = MoviePreviewMapper()
            let existing: MoviesMoviePreviewEntity?
            do {
                existing = try modelContext.fetch(descriptor).first
            } catch let error {
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

            let itemEntity = MoviesRecommendationMovieItemEntity(
                movieID: movieID,
                sortIndex: index,
                page: page,
                movie: previewEntity
            )
            modelContext.insert(itemEntity)
        }

        do {
            try modelContext.save()
        } catch let error {
            throw .persistence(error)
        }
    }

    func recommendationsStream(
        forMovie movieID: Int,
        limit: Int? = nil
    ) -> AsyncThrowingStream<[MoviePreview]?, Error> {
        var descriptor = FetchDescriptor<MoviesRecommendationMovieItemEntity>(
            predicate: #Predicate { $0.movieID == movieID },
            sortBy: [SortDescriptor(\.page), SortDescriptor(\.sortIndex)]
        )
        descriptor.fetchLimit = limit
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

    func currentRecommendationsStreamPage(
        forMovie movieID: Int
    ) async throws(MovieRecommendationLocalDataSourceError) -> Int? {
        var descriptor = FetchDescriptor<MoviesRecommendationMovieItemEntity>(
            predicate: #Predicate { $0.movieID == movieID },
            sortBy: [SortDescriptor(\.page, order: .reverse)]
        )
        descriptor.fetchLimit = 1

        let entity: MoviesRecommendationMovieItemEntity?
        do {
            entity = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        return entity?.page
    }

}
