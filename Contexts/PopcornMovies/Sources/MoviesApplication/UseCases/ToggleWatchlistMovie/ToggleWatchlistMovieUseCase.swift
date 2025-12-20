//
//  ToggleWatchlistMovieUseCase.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol ToggleWatchlistMovieUseCase: Sendable {

    func execute(id: Int) async throws(ToggleWatchlistMovieError)

}
