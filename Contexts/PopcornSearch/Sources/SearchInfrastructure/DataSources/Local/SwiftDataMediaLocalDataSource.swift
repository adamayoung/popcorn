//
//  SwiftDataMediaLocalDataSource.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import DataPersistenceInfrastructure
import Foundation
import OSLog
import SearchDomain
import SwiftData

@ModelActor
actor SwiftDataMediaLocalDataSource: MediaLocalDataSource, SwiftDataFetchStreaming {

    private static let logger = Logger.searchInfrastructure

    func mediaSearchHistory() async throws(MediaLocalDataSourceError) -> [MediaSearchHistoryEntry] {
        let descriptor = FetchDescriptor<SearchMediaSearchHistoryEntryEntity>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )

        let entities: [SearchMediaSearchHistoryEntryEntity]
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
        let mediaType = SearchMediaSearchHistoryEntryEntity.MediaType.movie.rawValue
        let descriptor = FetchDescriptor<SearchMediaSearchHistoryEntryEntity>(
            predicate: #Predicate { $0.mediaType?.rawValue == mediaType },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )

        let entities: [SearchMediaSearchHistoryEntryEntity]
        do {
            entities = try modelContext.fetch(descriptor)
        } catch let error {
            throw .persistence(error)
        }

        let mapper = MovieSearchHistoryEntryMapper()
        let entries = entities.compactMap(mapper.map)

        return entries
    }

    func tvSeriesSearchHistory() async throws(MediaLocalDataSourceError) -> [TVSeriesSearchHistoryEntry] {
        let mediaType = SearchMediaSearchHistoryEntryEntity.MediaType.tvSeries.rawValue
        let descriptor = FetchDescriptor<SearchMediaSearchHistoryEntryEntity>(
            predicate: #Predicate { $0.mediaType?.rawValue == mediaType },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )

        let entities: [SearchMediaSearchHistoryEntryEntity]
        do {
            entities = try modelContext.fetch(descriptor)
        } catch let error {
            throw .persistence(error)
        }

        let mapper = TVSeriesSearchHistoryEntryMapper()
        let entries = entities.compactMap(mapper.map)

        return entries
    }

    func personSearchHistory() async throws(MediaLocalDataSourceError) -> [PersonSearchHistoryEntry] {
        let mediaType = SearchMediaSearchHistoryEntryEntity.MediaType.person.rawValue
        let descriptor = FetchDescriptor<SearchMediaSearchHistoryEntryEntity>(
            predicate: #Predicate { $0.mediaType?.rawValue == mediaType },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )

        let entities: [SearchMediaSearchHistoryEntryEntity]
        do {
            entities = try modelContext.fetch(descriptor)
        } catch let error {
            throw .persistence(error)
        }

        let mapper = PersonSearchHistoryEntryMapper()
        let entries = entities.compactMap(mapper.map)

        return entries
    }

    func saveMovieSearchHistoryEntry(_ entry: MovieSearchHistoryEntry) async throws(MediaLocalDataSourceError) {
        try await removeSearchHistoryEntry(withMediaID: entry.id)

        let entity = SearchMediaSearchHistoryEntryEntity(
            mediaID: entry.id,
            mediaType: .movie,
            timestamp: entry.timestamp
        )
        modelContext.insert(entity)

        do { try modelContext.save() } catch let error { throw .persistence(error) }
    }

    func saveTVSeriesSearchHistoryEntry(_ entry: TVSeriesSearchHistoryEntry) async throws(MediaLocalDataSourceError) {
        try await removeSearchHistoryEntry(withMediaID: entry.id)

        let entity = SearchMediaSearchHistoryEntryEntity(
            mediaID: entry.id,
            mediaType: .tvSeries,
            timestamp: entry.timestamp
        )
        modelContext.insert(entity)

        do { try modelContext.save() } catch let error { throw .persistence(error) }
    }

    func savePersonSearchHistoryEntry(_ entry: PersonSearchHistoryEntry) async throws(MediaLocalDataSourceError) {
        try await removeSearchHistoryEntry(withMediaID: entry.id)

        let entity = SearchMediaSearchHistoryEntryEntity(
            mediaID: entry.id,
            mediaType: .person,
            timestamp: entry.timestamp
        )
        modelContext.insert(entity)

        do { try modelContext.save() } catch let error { throw .persistence(error) }
    }

}

extension SwiftDataMediaLocalDataSource {

    private func removeSearchHistoryEntry(withMediaID id: Int) async throws(MediaLocalDataSourceError) {
        let descriptor = FetchDescriptor<SearchMediaSearchHistoryEntryEntity>(
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
