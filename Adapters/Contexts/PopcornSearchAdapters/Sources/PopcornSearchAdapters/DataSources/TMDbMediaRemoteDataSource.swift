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

final class TMDbMediaRemoteDataSource: MediaRemoteDataSource {

    private let searchService: any SearchService

    init(searchService: some SearchService) {
        self.searchService = searchService
    }

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
