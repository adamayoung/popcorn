//
//  MockGenreBackdropProvider.swift
//  PopcornGenres
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GenresDomain

final class MockGenreBackdropProvider: GenreBackdropProviding, @unchecked Sendable {

    var backdropPathCallCount = 0
    var backdropPathStubs: [Genre.ID: URL] = [:]
    var backdropPathError: GenreBackdropProviderError?

    func backdropPath(forGenreID genreID: Genre.ID) async throws(GenreBackdropProviderError) -> URL? {
        backdropPathCallCount += 1

        if let error = backdropPathError {
            throw error
        }

        return backdropPathStubs[genreID]
    }

}
