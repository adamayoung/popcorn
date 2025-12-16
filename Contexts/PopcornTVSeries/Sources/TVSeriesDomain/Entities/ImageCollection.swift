//
//  ImageCollection.swift
//  PopcornTVSeries
//
//  Created by Adam Young on 03/06/2025.
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
