//
//  WatchlistMovie+Mocks.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

extension WatchlistMovie {

    static func mock(
        id: Int = 1,
        createdAt: Date = Date(timeIntervalSince1970: 1_000_000)
    ) -> WatchlistMovie {
        WatchlistMovie(id: id, createdAt: createdAt)
    }

}
