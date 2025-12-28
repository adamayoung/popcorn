//
//  MoviePreviewDetails.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// Represents detailed movie preview information for UI display.
///
/// This model extends the basic movie preview with fully resolved image URL sets
/// at multiple resolutions, suitable for displaying movie cards and details in the UI.
///
public struct MoviePreviewDetails: Identifiable, Equatable, Sendable {

    /// The unique identifier for the movie.
    public let id: Int

    /// The movie's title.
    public let title: String

    /// A brief description or plot summary of the movie.
    public let overview: String

    /// URL set for the movie's poster image at various resolutions.
    public let posterURLSet: ImageURLSet?

    /// URL set for the movie's backdrop image at various resolutions.
    public let backdropURLSet: ImageURLSet?

    /// URL set for the movie's logo image at various resolutions.
    public let logoURLSet: ImageURLSet?

    ///
    /// Creates a new movie preview details instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the movie.
    ///   - title: The movie's title.
    ///   - overview: A brief description or plot summary.
    ///   - posterURLSet: URL set for the poster image. Defaults to `nil`.
    ///   - backdropURLSet: URL set for the backdrop image. Defaults to `nil`.
    ///   - logoURLSet: URL set for the logo image. Defaults to `nil`.
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
