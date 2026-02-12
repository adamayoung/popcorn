//
//  MockSearchService.swift
//  PopcornSearchAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TMDb

final class MockSearchService: SearchService, @unchecked Sendable {

    struct SearchAllCall: Equatable {
        let query: String
        let page: Int?
        let language: String?
    }

    var searchAllCallCount = 0
    var searchAllCalledWith: [SearchAllCall] = []
    var searchAllStub: Result<MediaPageableList, TMDbError>?

    func searchAll(
        query: String,
        filter: AllMediaSearchFilter?,
        page: Int?,
        language: String?
    ) async throws -> MediaPageableList {
        searchAllCallCount += 1
        searchAllCalledWith.append(SearchAllCall(query: query, page: page, language: language))

        guard let stub = searchAllStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let result):
            return result
        case .failure(let error):
            throw error
        }
    }

    func searchMovies(
        query: String,
        filter: MovieSearchFilter?,
        page: Int?,
        language: String?
    ) async throws -> MoviePageableList {
        fatalError("Not implemented")
    }

    func searchTVSeries(
        query: String,
        filter: TVSeriesSearchFilter?,
        page: Int?,
        language: String?
    ) async throws -> TVSeriesPageableList {
        fatalError("Not implemented")
    }

    func searchPeople(
        query: String,
        filter: PersonSearchFilter?,
        page: Int?,
        language: String?
    ) async throws -> PersonPageableList {
        fatalError("Not implemented")
    }

    func searchCollections(
        query: String,
        page: Int?,
        language: String?
    ) async throws -> CollectionPageableList {
        fatalError("Not implemented")
    }

    func searchCompanies(
        query: String,
        page: Int?
    ) async throws -> CompanyPageableList {
        fatalError("Not implemented")
    }

    func searchKeywords(
        query: String,
        page: Int?
    ) async throws -> KeywordPageableList {
        fatalError("Not implemented")
    }

}
