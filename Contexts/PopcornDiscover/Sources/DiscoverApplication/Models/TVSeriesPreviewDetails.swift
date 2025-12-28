//
//  TVSeriesPreviewDetails.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import DiscoverDomain
import Foundation

///
/// Represents enriched TV series preview data for display in discovery interfaces.
///
/// This model extends basic TV series preview information with resolved genre objects
/// and complete image URL sets at various sizes, ready for UI presentation.
///
public struct TVSeriesPreviewDetails: Identifiable, Equatable, Sendable {

    /// The unique identifier for the TV series.
    public let id: Int

    /// The TV series' name.
    public let name: String

    /// A brief description or summary of the TV series.
    public let overview: String

    /// The date when the first episode aired.
    public let firstAirDate: Date

    /// Array of resolved genre objects for this TV series.
    public let genres: [Genre]

    /// URL set for the TV series' poster image at various sizes.
    public let posterURLSet: ImageURLSet?

    /// URL set for the TV series' backdrop image at various sizes.
    public let backdropURLSet: ImageURLSet?

    /// URL set for the TV series' logo image at various sizes.
    public let logoURLSet: ImageURLSet?

    ///
    /// Creates a new TV series preview details instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the TV series.
    ///   - name: The TV series' name.
    ///   - overview: A brief description or summary.
    ///   - firstAirDate: The date of the first episode.
    ///   - genres: Array of resolved genre objects.
    ///   - posterURLSet: URL set for poster images. Defaults to `nil`.
    ///   - backdropURLSet: URL set for backdrop images. Defaults to `nil`.
    ///   - logoURLSet: URL set for logo images. Defaults to `nil`.
    ///
    public init(
        id: Int,
        name: String,
        overview: String,
        firstAirDate: Date,
        genres: [Genre],
        posterURLSet: ImageURLSet? = nil,
        backdropURLSet: ImageURLSet? = nil,
        logoURLSet: ImageURLSet? = nil
    ) {
        self.id = id
        self.name = name
        self.overview = overview
        self.firstAirDate = firstAirDate
        self.genres = genres
        self.posterURLSet = posterURLSet
        self.backdropURLSet = backdropURLSet
        self.logoURLSet = logoURLSet
    }

}
