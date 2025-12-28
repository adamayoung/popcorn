//
//  MoviePreviewDetails.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// A detailed movie preview model for presentation in the UI.
///
/// This model extends the basic movie preview with resolved image URL sets
/// at various resolutions, suitable for direct use in views.
///
public struct MoviePreviewDetails: Identifiable, Equatable, Sendable {

    /// The unique identifier for the movie.
    public let id: Int

    /// The movie's title.
    public let title: String

    /// A brief description or plot summary of the movie.
    public let overview: String

    /// URL set containing poster images at various resolutions.
    public let posterURLSet: ImageURLSet?

    /// URL set containing backdrop images at various resolutions.
    public let backdropURLSet: ImageURLSet?

    /// URL set containing logo images at various resolutions.
    public let logoURLSet: ImageURLSet?

    ///
    /// Creates a new movie preview details instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the movie.
    ///   - title: The movie's title.
    ///   - overview: A brief description or plot summary.
    ///   - posterURLSet: URL set for poster images. Defaults to `nil`.
    ///   - backdropURLSet: URL set for backdrop images. Defaults to `nil`.
    ///   - logoURLSet: URL set for logo images. Defaults to `nil`.
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
