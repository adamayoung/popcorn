//
//  MockToggleWatchlistMovieUseCase.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesApplication

struct MockToggleWatchlistMovieUseCase: ToggleWatchlistMovieUseCase, Sendable {

    var onToggle: (@Sendable (Int) async -> Void)?

    func execute(id: Int) async throws(ToggleWatchlistMovieError) {
        await onToggle?(id)
    }

}
