//
//  MovieCreditsLocalDataSource.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

public protocol MovieCreditsLocalDataSource: Sendable, Actor {

    func credits(forMovie movieID: Int) async throws(MovieCreditsLocalDataSourceError) -> Credits?

    func setCredits(
        _ credits: Credits,
        forMovie movieID: Int
    ) async throws(MovieCreditsLocalDataSourceError)

}

public enum MovieCreditsLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
