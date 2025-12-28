//
//  MoviePreviewDetails.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// Represents a lightweight movie preview ready for presentation.
///
/// This model is used in list contexts such as popular movies, similar movies,
/// and recommendations. It includes resolved image URLs at multiple sizes for
/// efficient display in collection views and carousels.
///
public struct MoviePreviewDetails: Identifiable, Equatable, Sendable {

    /// The unique identifier for the movie.
    public let id: Int

    /// The movie's title.
    public let title: String

    /// A brief description or plot summary of the movie.
    public let overview: String

    /// A set of poster image URLs at various resolutions.
    public let posterURLSet: ImageURLSet?

    /// A set of backdrop image URLs at various resolutions.
    public let backdropURLSet: ImageURLSet?

    /// A set of logo image URLs at various resolutions.
    public let logoURLSet: ImageURLSet?

    ///
    /// Creates a new movie preview details instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the movie.
    ///   - title: The movie's title.
    ///   - overview: A brief description or plot summary.
    ///   - posterURLSet: A set of poster image URLs. Defaults to `nil`.
    ///   - backdropURLSet: A set of backdrop image URLs. Defaults to `nil`.
    ///   - logoURLSet: A set of logo image URLs. Defaults to `nil`.
    ///
    public init(
        id: Int,
        title: String,
        overview: String,
        posterURLSet: ImageURLSet? = nil,
        backdropURLSet: ImageURLSet? = nil,
        logoURLSet: ImageURLSet? = nil
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterURLSet = posterURLSet
        self.backdropURLSet = backdropURLSet
        self.logoURLSet = logoURLSet
    }

}
