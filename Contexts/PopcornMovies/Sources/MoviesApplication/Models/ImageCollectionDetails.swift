//
//  ImageCollectionDetails.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// Represents a collection of movie images ready for presentation.
///
/// This model contains arrays of resolved image URLs at multiple sizes for
/// posters, backdrops, and logos associated with a movie. Each image type
/// includes multiple variations for different display contexts.
///
public struct ImageCollectionDetails: Sendable {

    /// The unique identifier for the movie this image collection belongs to.
    public let id: Int

    /// Arrays of poster image URL sets at various resolutions.
    public let posterURLSets: [ImageURLSet]

    /// Arrays of backdrop image URL sets at various resolutions.
    public let backdropURLSets: [ImageURLSet]

    /// Arrays of logo image URL sets at various resolutions.
    public let logoURLSets: [ImageURLSet]

    ///
    /// Creates a new image collection details instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the movie.
    ///   - posterURLSets: Arrays of poster image URL sets.
    ///   - backdropURLSets: Arrays of backdrop image URL sets.
    ///   - logoURLSets: Arrays of logo image URL sets.
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
