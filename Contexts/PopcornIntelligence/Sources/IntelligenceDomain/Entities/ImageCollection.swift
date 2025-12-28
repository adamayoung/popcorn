//
//  ImageCollection.swift
//  PopcornIntelligence
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Represents a collection of images associated with a movie.
///
/// This entity aggregates various types of promotional and branding images for a movie,
/// including posters, backdrops, and logos. Each image type is stored as a collection
/// of URL paths, allowing the application to display multiple variations or sizes.
///
public struct ImageCollection: Sendable, Equatable {

    /// The unique identifier for the movie this image collection belongs to.
    public let id: Int

    /// URL paths to poster images for the movie.
    public let posterPaths: [URL]

    /// URL paths to backdrop images for the movie.
    public let backdropPaths: [URL]

    /// URL paths to logo images for the movie.
    public let logoPaths: [URL]

    ///
    /// Creates a new image collection instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the movie.
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
