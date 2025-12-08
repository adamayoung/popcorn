//
//  MediaSearchRepository.swift
//  PopcornSearch
//
//  Created by Adam Young on 25/11/2025.
//

import Foundation

public protocol MediaRepository: Sendable {

    func search(query: String, page: Int) async throws(MediaRepositoryError) -> [MediaPreview]

    func mediaSearchHistory() async throws(MediaRepositoryError) -> [MediaSearchHistoryEntry]

    func saveMovieSearchHistoryEntry(_ entry: MovieSearchHistoryEntry)
        async throws(MediaRepositoryError)

    func saveTVSeriesSearchHistoryEntry(_ entry: TVSeriesSearchHistoryEntry)
        async throws(MediaRepositoryError)

    func savePersonSearchHistoryEntry(_ entry: PersonSearchHistoryEntry)
        async throws(MediaRepositoryError)

}

public enum MediaRepositoryError: Error {

    case unauthorised
    case unknown(Error?)

}
