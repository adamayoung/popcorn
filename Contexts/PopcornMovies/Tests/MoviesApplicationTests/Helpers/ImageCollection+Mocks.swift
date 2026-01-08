//
//  ImageCollection+Mocks.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

extension ImageCollection {

    static func mock(
        id: Int = 1,
        posterPaths: [URL] = ["/poster1.jpg"].compactMap { URL(string: $0) },
        backdropPaths: [URL] = ["/backdrop1.jpg"].compactMap { URL(string: $0) },
        logoPaths: [URL] = ["/logo1.jpg"].compactMap { URL(string: $0) }
    ) -> ImageCollection {
        ImageCollection(
            id: id,
            posterPaths: posterPaths,
            backdropPaths: backdropPaths,
            logoPaths: logoPaths
        )
    }

}
