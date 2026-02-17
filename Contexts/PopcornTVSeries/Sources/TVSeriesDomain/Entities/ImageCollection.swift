//
//  ImageCollection.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents a collection of images associated with a TV series.
///
/// This entity aggregates various types of promotional and branding images for a TV series,
/// including posters, backdrops, and logos. Each image type is stored as a collection
/// of URL paths, allowing the application to display multiple variations or sizes.
///
public struct ImageCollection: Sendable {

    /// The unique identifier for the TV series this image collection belongs to.
    public let id: Int

    /// URL paths to poster images for the TV series.
    public let posterPaths: [URL]

    /// URL paths to backdrop images for the TV series.
    public let backdropPaths: [URL]

    /// URL paths to logo images for the TV series.
    public let logoPaths: [URL]

    ///
    /// Creates a new image collection instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the TV series.
    ///   - posterPaths: Array of URL paths to poster images.
    ///   - backdropPaths: Array of URL paths to backdrop images.
    ///   - logoPaths: Array of URL paths to logo images.
    ///
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
