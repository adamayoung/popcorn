//
//  ToggleWatchlistMovieUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol ToggleWatchlistMovieUseCase: Sendable {

    func execute(id: Int) async throws(ToggleWatchlistMovieError)

}
