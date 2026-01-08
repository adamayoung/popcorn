//
//  MockMediaRemoteDataSource.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SearchDomain
import SearchInfrastructure

final class MockMediaRemoteDataSource: MediaRemoteDataSource, @unchecked Sendable {

    var searchCallCount = 0
    var searchCalledWith: [(query: String, page: Int)] = []
    var searchStub: Result<[MediaPreview], MediaRemoteDataSourceError>?

    func search(query: String, page: Int) async throws(MediaRemoteDataSourceError) -> [MediaPreview] {
        searchCallCount += 1
        searchCalledWith.append((query: query, page: page))

        guard let stub = searchStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let media):
            return media
        case .failure(let error):
            throw error
        }
    }

}
