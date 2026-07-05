//
//  Movie+Mocks.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PlotRemixGameDomain

extension Movie {

    static func mock(
        id: Int = 1,
        title: String = "Test Movie",
        overview: String = "A test overview.",
        posterPath: URL? = nil,
        backdropPath: URL? = nil
    ) -> Movie {
        Movie(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath
        )
    }

}
