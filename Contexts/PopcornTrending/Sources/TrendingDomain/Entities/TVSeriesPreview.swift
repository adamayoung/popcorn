//
//  TVSeriesPreview.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents a trending TV series preview.
///
/// This entity contains essential TV series information for displaying in trending lists.
/// It includes the core details needed to present a series in trending rankings
/// without additional metadata like genre or air dates.
///
public struct TVSeriesPreview: Identifiable, Equatable, Sendable {

    /// The unique identifier for the TV series.
    public let id: Int

    /// The TV series' name.
    public let name: String

    /// A brief description or summary of the TV series.
    public let overview: String

    /// URL path to the TV series' poster image.
    public let posterPath: URL?

    /// URL path to the TV series' backdrop image.
    public let backdropPath: URL?

    ///
    /// Creates a new trending TV series preview instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the TV series.
    ///   - name: The TV series' name.
    ///   - overview: A brief description or summary.
    ///   - posterPath: URL path to the poster image. Defaults to `nil`.
    ///   - backdropPath: URL path to the backdrop image. Defaults to `nil`.
    ///
    public init(
        id: Int,
        name: String,
        overview: String,
        posterPath: URL? = nil,
        backdropPath: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }

}
