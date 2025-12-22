//
//  TVSeriesPreview.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Represents a TV series preview in the discover context.
///
/// This entity extends the basic TV series preview with genre information, enabling
/// users to discover and browse TV series by genre. It includes all essential series
/// details needed for displaying in discovery lists and grids.
///
public struct TVSeriesPreview: Identifiable, Equatable, Sendable {

    /// The unique identifier for the TV series.
    public let id: Int

    /// The TV series' name.
    public let name: String

    /// A brief description or summary of the TV series.
    public let overview: String

    /// The date when the first episode aired.
    public let firstAirDate: Date

    /// Array of genre IDs associated with this TV series.
    public let genreIDs: [Int]

    /// URL path to the TV series' poster image.
    public let posterPath: URL?

    /// URL path to the TV series' backdrop image.
    public let backdropPath: URL?

    ///
    /// Creates a new discover TV series preview instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the TV series.
    ///   - name: The TV series' name.
    ///   - overview: A brief description or summary.
    ///   - firstAirDate: The date of the first episode.
    ///   - genreIDs: Array of genre IDs for this series.
    ///   - posterPath: URL path to the poster image. Defaults to `nil`.
    ///   - backdropPath: URL path to the backdrop image. Defaults to `nil`.
    ///
    public init(
        id: Int,
        name: String,
        overview: String,
        firstAirDate: Date,
        genreIDs: [Int],
        posterPath: URL? = nil,
        backdropPath: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.overview = overview
        self.firstAirDate = firstAirDate
        self.genreIDs = genreIDs
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }

}
