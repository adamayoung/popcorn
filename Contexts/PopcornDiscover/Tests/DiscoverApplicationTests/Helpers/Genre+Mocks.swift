//
//  Genre+Mocks.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation

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
