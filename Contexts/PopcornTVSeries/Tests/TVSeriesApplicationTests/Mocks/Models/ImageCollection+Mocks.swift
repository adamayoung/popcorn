//
//  ImageCollection+Mocks.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TVSeriesDomain

extension ImageCollection {

    static func mock(
        id: Int = 1396,
        posterPaths: [URL] = [URL(string: "/poster1.jpg"), URL(string: "/poster2.jpg")].compactMap(\.self),
        backdropPaths: [URL] = [URL(string: "/back1.jpg")].compactMap(\.self),
        logoPaths: [URL] = [URL(string: "/logo1.jpg")].compactMap(\.self)
    ) -> ImageCollection {
        ImageCollection(
            id: id,
            posterPaths: posterPaths,
            backdropPaths: backdropPaths,
            logoPaths: logoPaths
        )
    }

}
