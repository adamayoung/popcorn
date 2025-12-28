//
//  ImageCollectionDetails.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// Represents a collection of image URL sets for a TV series.
///
/// This application model provides fully-resolved image URLs at multiple sizes
/// for posters, backdrops, and logos. Each image type contains an array of
/// ``ImageURLSet`` instances, allowing display of multiple images per category.
///
public struct ImageCollectionDetails: Sendable {

    /// The unique identifier for the TV series this image collection belongs to.
    public let id: Int

    /// URL sets for poster images at various resolutions.
    public let posterURLSets: [ImageURLSet]

    /// URL sets for backdrop images at various resolutions.
    public let backdropURLSets: [ImageURLSet]

    /// URL sets for logo images at various resolutions.
    public let logoURLSets: [ImageURLSet]

    ///
    /// Creates a new image collection details instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the TV series.
    ///   - posterURLSets: URL sets for poster images.
    ///   - backdropURLSets: URL sets for backdrop images.
    ///   - logoURLSets: URL sets for logo images.
    ///
    public init(
        id: Int,
        posterURLSets: [ImageURLSet],
        backdropURLSets: [ImageURLSet],
        logoURLSets: [ImageURLSet]
    ) {
        self.id = id
        self.posterURLSets = posterURLSets
        self.backdropURLSets = backdropURLSets
        self.logoURLSets = logoURLSets
    }

}
