//
//  FetchWatchlistMoviesUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol FetchWatchlistMoviesUseCase: Sendable {

    func execute() async throws(FetchWatchlistMoviesError) -> [MoviePreviewDetails]

}
