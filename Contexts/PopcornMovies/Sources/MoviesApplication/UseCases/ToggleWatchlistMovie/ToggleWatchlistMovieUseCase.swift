//
//  ToggleWatchlistMovieUseCase.swift
//  PopcornMovies
//
//  Created by Adam Young on 03/12/2025.
//

import Foundation

public protocol ToggleWatchlistMovieUseCase: Sendable {

    func execute(id: Int) async throws(ToggleWatchlistMovieError)

}
