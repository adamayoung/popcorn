//
//  ImageCollection.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct ImageCollection: Sendable {

    public let id: Int
    public let posterPaths: [URL]
    public let backdropPaths: [URL]
    public let logoPaths: [URL]

    public init(
        id: Int,
        posterPaths: [URL],
        backdropPaths: [URL],
        logoPaths: [URL]
    ) {
        self.id = id
        self.posterPaths = posterPaths
        self.backdropPaths = backdropPaths
        self.logoPaths = logoPaths
    }

}
