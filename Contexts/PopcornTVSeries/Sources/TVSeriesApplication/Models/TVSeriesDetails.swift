//
//  TVSeriesDetails.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// Represents detailed information about a TV series for presentation.
///
/// This application model combines TV series metadata with fully-resolved image URLs
/// at multiple sizes. It is the primary data structure returned by the
/// ``FetchTVSeriesDetailsUseCase`` for display in the UI layer.
///
public struct TVSeriesDetails: Identifiable, Equatable, Sendable {

    /// The unique identifier for the TV series.
    public let id: Int

    /// The TV series' name.
    public let name: String

    /// The TV series' tagline.
    public let tagline: String?

    /// A brief description or summary of the TV series.
    public let overview: String

    /// The total number of seasons in the TV series.
    public let numberOfSeasons: Int

    /// The date the TV series first aired.
    public let firstAirDate: Date?

    /// URL set for the poster image at various resolutions.
    public let posterURLSet: ImageURLSet?

    /// URL set for the backdrop image at various resolutions.
    public let backdropURLSet: ImageURLSet?

    /// URL set for the logo image at various resolutions.
    public let logoURLSet: ImageURLSet?

    ///
    /// Creates a new TV series details instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the TV series.
    ///   - name: The TV series' name.
    ///   - tagline: The TV series' tagline. Defaults to `nil`.
    ///   - overview: A brief description or summary.
    ///   - numberOfSeasons: The total number of seasons.
    ///   - firstAirDate: The date the series first aired. Defaults to `nil`.
    ///   - posterURLSet: URL set for the poster image. Defaults to `nil`.
    ///   - backdropURLSet: URL set for the backdrop image. Defaults to `nil`.
    ///   - logoURLSet: URL set for the logo image. Defaults to `nil`.
    ///
    public init(
        id: Int,
        name: String,
        tagline: String? = nil,
        overview: String,
        numberOfSeasons: Int,
        firstAirDate: Date? = nil,
        posterURLSet: ImageURLSet? = nil,
        backdropURLSet: ImageURLSet? = nil,
        logoURLSet: ImageURLSet? = nil
    ) {
        self.id = id
        self.name = name
        self.tagline = tagline
        self.overview = overview
        self.numberOfSeasons = numberOfSeasons
        self.firstAirDate = firstAirDate
        self.posterURLSet = posterURLSet
        self.backdropURLSet = backdropURLSet
        self.logoURLSet = logoURLSet
    }

}
