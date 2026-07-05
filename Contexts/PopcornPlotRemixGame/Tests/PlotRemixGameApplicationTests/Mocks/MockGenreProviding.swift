//
//  MockGenreProviding.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PlotRemixGameDomain

final class MockGenreProviding: GenreProviding, @unchecked Sendable {

    var moviesCallCount = 0
    var moviesStub: Result<[Genre], GenreProviderError>?

    func movies() async throws(GenreProviderError) -> [Genre] {
        moviesCallCount += 1

        guard let stub = moviesStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let genres):
            return genres
        case .failure(let error):
            throw error
        }
    }

}
