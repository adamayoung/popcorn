//
//  SwiftDataMediaLocalDataSource.swift
//  SearchKit
//
//  Created by Adam Young on 04/12/2025.
//

import DataPersistenceInfrastructure
import Foundation
import OSLog
import SearchDomain
import SwiftData

@ModelActor
actor SwiftDataMediaLocalDataSource: MediaLocalDataSource,
    SwiftDataFetchStreaming, Sendable
{

    private static let logger = Logger(
        subsystem: "SearchKit",
        category: "SwiftDataMediaLocalDataSource"
    )

    func mediaSearchHistory() async throws(MediaLocalDataSourceError) -> [MediaSearchHistoryEntry] {
        let descriptor = FetchDescriptor<MediaSearchHistoryEntryEntity>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )

        let entities: [MediaSearchHistoryEntryEntity]
        do {
            entities = try modelContext.fetch(descriptor)
        } catch let error {
            throw .persistence(error)
        }

        let mapper = MediaSearchHistoryEntryMapper()
        let entries = entities.compactMap(mapper.map)

        return entries
    }

    func movieSearchHistory() async throws(MediaLocalDataSourceError) -> [MovieSearchHistoryEntry] {
        let mediaType = MediaSearchHistoryEntryEntity.MediaType.movie.rawValue
        let descriptor = FetchDescriptor<MediaSearchHistoryEntryEntity>(
            predicate: #Predicate { $0.mediaType?.rawValue == mediaType },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )

        let entities: [MediaSearchHistoryEntryEntity]
        do {
            entities = try modelContext.fetch(descriptor)
        } catch let error {
            throw .persistence(error)
        }

        let mapper = MovieSearchHistoryEntryMapper()
        let entries = entities.compactMap(mapper.map)

        return entries
    }

    func tvSeriesSearchHistory() async throws(MediaLocalDataSourceError)
        -> [TVSeriesSearchHistoryEntry]
    {
        let mediaType = MediaSearchHistoryEntryEntity.MediaType.tvSeries.rawValue
        let descriptor = FetchDescriptor<MediaSearchHistoryEntryEntity>(
            predicate: #Predicate { $0.mediaType?.rawValue == mediaType },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )

        let entities: [MediaSearchHistoryEntryEntity]
        do {
            entities = try modelContext.fetch(descriptor)
        } catch let error {
            throw .persistence(error)
        }

        let mapper = TVSeriesSearchHistoryEntryMapper()
        let entries = entities.compactMap(mapper.map)

        return entries
    }

    func personSearchHistory() async throws(MediaLocalDataSourceError) -> [PersonSearchHistoryEntry]
    {
        let mediaType = MediaSearchHistoryEntryEntity.MediaType.person.rawValue
        let descriptor = FetchDescriptor<MediaSearchHistoryEntryEntity>(
            predicate: #Predicate { $0.mediaType?.rawValue == mediaType },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )

        let entities: [MediaSearchHistoryEntryEntity]
        do {
            entities = try modelContext.fetch(descriptor)
        } catch let error {
            throw .persistence(error)
        }

        let mapper = PersonSearchHistoryEntryMapper()
        let entries = entities.compactMap(mapper.map)

        return entries
    }

    func saveMovieSearchHistoryEntry(_ entry: MovieSearchHistoryEntry)
        async throws(MediaLocalDataSourceError)
    {
        try await removeSearchHistoryEntry(withMediaID: entry.id)

        let entity = MediaSearchHistoryEntryEntity(
            mediaID: entry.id,
            mediaType: .movie,
            timestamp: entry.timestamp
        )
        modelContext.insert(entity)

        do { try modelContext.save() } catch let error { throw .persistence(error) }
    }

    func saveTVSeriesSearchHistoryEntry(_ entry: TVSeriesSearchHistoryEntry)
        async throws(MediaLocalDataSourceError)
    {
        try await removeSearchHistoryEntry(withMediaID: entry.id)

        let entity = MediaSearchHistoryEntryEntity(
            mediaID: entry.id,
            mediaType: .tvSeries,
            timestamp: entry.timestamp
        )
        modelContext.insert(entity)

        do { try modelContext.save() } catch let error { throw .persistence(error) }
    }

    func savePersonSearchHistoryEntry(_ entry: PersonSearchHistoryEntry)
        async throws(MediaLocalDataSourceError)
    {
        try await removeSearchHistoryEntry(withMediaID: entry.id)

        let entity = MediaSearchHistoryEntryEntity(
            mediaID: entry.id,
            mediaType: .person,
            timestamp: entry.timestamp
        )
        modelContext.insert(entity)

        do { try modelContext.save() } catch let error { throw .persistence(error) }
    }

}

extension SwiftDataMediaLocalDataSource {

    private func removeSearchHistoryEntry(withMediaID id: Int)
        async throws(MediaLocalDataSourceError)
    {
        let descriptor = FetchDescriptor<MediaSearchHistoryEntryEntity>(
            predicate: #Predicate { $0.mediaID == id }
        )
        do {
            let entities = try modelContext.fetch(descriptor)
            entities.forEach(modelContext.delete)
            try modelContext.save()
        } catch let error {
            throw .persistence(error)
        }
    }

}
