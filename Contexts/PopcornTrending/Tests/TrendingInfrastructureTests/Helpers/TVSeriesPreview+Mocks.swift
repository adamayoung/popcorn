//
//  TVSeriesPreview+Mocks.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TrendingDomain

extension TVSeriesPreview {

    static func mock(
        id: Int = 1,
        name: String = "Game of Thrones",
        overview: String = "Seven noble families fight for control of the mythical land of Westeros.",
        posterPath: URL? = URL(string: "/poster.jpg"),
        backdropPath: URL? = URL(string: "/backdrop.jpg")
    ) -> TVSeriesPreview {
        TVSeriesPreview(
            id: id,
            name: name,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath
        )
    }

    static var mocks: [TVSeriesPreview] {
        [
            .mock(id: 1, name: "Series One"),
            .mock(id: 2, name: "Series Two"),
            .mock(id: 3, name: "Series Three")
        ]
    }

}
