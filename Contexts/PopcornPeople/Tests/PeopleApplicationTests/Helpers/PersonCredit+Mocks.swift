//
//  PersonCredit+Mocks.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PeopleDomain

extension PersonCredit {

    static func mock(
        id: Int = 1,
        mediaType: MediaType = .movie,
        title: String = "Forrest Gump",
        backdropPath: URL? = URL(string: "/backdrop.jpg"),
        posterPath: URL? = URL(string: "/poster.jpg"),
        popularity: Double? = 10.0,
        role: Role = .cast
    ) -> PersonCredit {
        PersonCredit(
            id: id,
            mediaType: mediaType,
            title: title,
            backdropPath: backdropPath,
            posterPath: posterPath,
            popularity: popularity,
            role: role
        )
    }

}
