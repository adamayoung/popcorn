//
//  SwiftDataDiscoverMovieLocalDataSource.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import DataPersistenceInfrastructure
import DiscoverDomain
import Foundation
import OSLog
import SwiftData

@ModelActor
actor SwiftDataDiscoverMovieLocalDataSource: DiscoverMovieLocalDataSource,
SwiftDataFetchStreaming {

    private static let logger = Logger.discoverInfrastructure

    private var ttl: TimeInterval = 60 * 60 * 24 // 1 day

    func movies(
        filter: MovieFilter?,
        page: Int
    ) async throws(DiscoverMovieLocalDataSourceError) -> MoviePreviewPage? {
        let filterKey = filter?.description
        let descriptor = FetchDescriptor<DiscoverMovieItemEntity>(
            predicate: #Predicate { $0.page == page && $0.filterKey == filterKey },
            sortBy: [SortDescriptor(\.sortIndex)]
        )

        let entities: [DiscoverMovieItemEntity]
        do {
            entities = try modelContext.fetch(descriptor)
        } catch let error {
            throw .persistence(error)
        }

        guard !entities.isEmpty else {
            Self.logger.debug(
                "SwiftData MISS: DiscoverMovies(filter: \(filterKey ?? "nil", privacy: .public), page: \(page, privacy: .public))"
            )
            return nil
        }

        let anyExpired = entities.contains { entity in
            entity.isExpired(ttl: ttl) || entity.movie?.isExpired(ttl: ttl) == true
        }

        if anyExpired {
            Self.logger.debug(
                "SwiftData EXPIRED: DiscoverMovies(filter: \(filterKey ?? "nil", privacy: .public), page: \(page, privacy: .public)) — deleting"
            )

            let deleteDescriptor = FetchDescriptor<DiscoverMovieItemEntity>(
                predicate: #Predicate { $0.page >= page && $0.filterKey == filterKey }
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

        // A page cached before `totalPages` was stored (a pre-migration row) has
        // no pagination metadata, so it can't be reconstructed into a page — treat
        // it as a miss. The caller's write-through then deletes and rewrites it
        // with metadata, so this self-heals on the next fetch.
        guard let totalPages = entities.first?.totalPages else {
            Self.logger.debug(
                "SwiftData MISS (no page metadata): DiscoverMovies(filter: \(filterKey ?? "nil", privacy: .public), page: \(page, privacy: .public))"
            )
            return nil
        }

        Self.logger.debug(
            "SwiftData HIT: DiscoverMovies(filter: \(filterKey ?? "nil", privacy: .public), page: \(page, privacy: .public))"
        )

        let mapper = MoviePreviewMapper()
        let movies = entities.compactMap {
            mapper.compactMap($0.movie)
        }

        return MoviePreviewPage(page: page, totalPages: totalPages, movies: movies)
    }

    func moviesStream(
        filter: MovieFilter?
    ) async -> AsyncThrowingStream<[MoviePreview]?, any Error> {
        let filterKey = filter?.description
        let descriptor = FetchDescriptor<DiscoverMovieItemEntity>(
            predicate: #Predicate { $0.filterKey == filterKey },
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

    func currentMoviesStreamPage(
        filter: MovieFilter?
    ) async throws(DiscoverMovieLocalDataSourceError) -> Int? {
        let filterKey = filter?.description
        var descriptor = FetchDescriptor<DiscoverMovieItemEntity>(
            predicate: #Predicate { $0.filterKey == filterKey },
            sortBy: [SortDescriptor(\.page, order: .reverse)]
        )
        descriptor.fetchLimit = 1

        let entity: DiscoverMovieItemEntity?
        do {
            entity = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        return entity?.page
    }

    func setMovies(
        _ page: MoviePreviewPage,
        filter: MovieFilter?
    ) async throws(DiscoverMovieLocalDataSourceError) {
        let filterKey = filter?.description
        let pageNumber = page.page
        let totalPages = page.totalPages
        let deleteDescriptor = FetchDescriptor<DiscoverMovieItemEntity>(
            predicate: #Predicate { $0.page >= pageNumber && $0.filterKey == filterKey }
        )
        do {
            let entitiesToDelete = try modelContext.fetch(deleteDescriptor)
            entitiesToDelete.forEach(modelContext.delete)
            try modelContext.save()
        } catch let error {
            throw .persistence(error)
        }

        for (index, preview) in page.movies.enumerated() {
            let id = preview.id
            let descriptor = FetchDescriptor<DiscoverMoviePreviewEntity>(
                predicate: #Predicate { $0.movieID == id }
            )
            let mapper = MoviePreviewMapper()
            let existing: DiscoverMoviePreviewEntity?
            do { existing = try modelContext.fetch(descriptor).first } catch let error {
                throw .persistence(error)
            }

            let previewEntity: DiscoverMoviePreviewEntity
            if let existing {
                mapper.map(preview, to: existing)
                previewEntity = existing
            } else {
                let entity = mapper.map(preview)
                modelContext.insert(entity)
                previewEntity = entity
            }

            let itemEntity = DiscoverMovieItemEntity(
                sortIndex: index,
                page: pageNumber,
                totalPages: totalPages,
                filterKey: filterKey,
                movie: previewEntity
            )
            modelContext.insert(itemEntity)
        }

        do { try modelContext.save() } catch let error { throw .persistence(error) }
    }

}
