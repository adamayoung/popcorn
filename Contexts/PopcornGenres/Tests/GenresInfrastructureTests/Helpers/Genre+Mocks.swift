//
//  Genre+Mocks.swift
//  PopcornGenres
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GenresDomain

extension Genre {

    static func mock(
        id: Int = 28,
        name: String = "Action"
    ) -> Genre {
        Genre(id: id, name: name)
    }

    static var mocks: [Genre] {
        [
            .mock(id: 28, name: "Action"),
            .mock(id: 12, name: "Adventure"),
            .mock(id: 35, name: "Comedy")
        ]
    }

}
