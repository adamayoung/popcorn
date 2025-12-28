//
//  TMDbMediaRemoteDataSource.swift
//  PopcornSearchAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SearchDomain
import SearchInfrastructure
import TMDb

///
/// A remote data source for searching media content using TMDb.
///
/// This class implements ``MediaRemoteDataSource`` by leveraging the TMDb search API
/// to find movies, TV series, and people matching a query.
///
final class TMDbMediaRemoteDataSource: MediaRemoteDataSource {

    private let searchService: any SearchService

    ///
    /// Creates a new TMDb media remote data source.
    ///
    /// - Parameter searchService: The TMDb service for searching media content.
    ///
    init(searchService: some SearchService) {
        self.searchService = searchService
    }

    ///
    /// Searches for media content matching a query.
    ///
    /// - Parameters:
    ///   - query: The search query string.
    ///   - page: The page number for paginated results.
    ///
    /// - Returns: An array of media previews matching the search query.
    ///
    /// - Throws: ``MediaRemoteDataSourceError`` if the search operation fails.
    ///
    func search(query: String, page: Int) async throws(MediaRemoteDataSourceError) -> [MediaPreview] {
        let tmdbMedia: [Media]
        do {
            tmdbMedia = try await searchService.searchAll(
                query: query,
                filter: nil,
                page: page,
                language: "en"
            ).results
        } catch let error {
            throw MediaRemoteDataSourceError(error)
        }

        let mapper = MediaPreviewMapper()
        return tmdbMedia.compactMap(mapper.map)
    }

}

private extension MediaRemoteDataSourceError {

    init(_ error: Error) {
        guard let error = error as? TMDbError else {
            self = .unknown(error)
            return
        }

        self.init(error)
    }

    init(_ error: TMDbError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

}
