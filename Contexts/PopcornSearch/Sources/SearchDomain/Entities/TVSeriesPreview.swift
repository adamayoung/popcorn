//
//  TVSeriesPreview.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Represents a simplified TV series preview in search results.
///
/// This entity provides essential TV series information optimized for search result displays,
/// containing only the core details needed for quick browsing and selection. Unlike the
/// full TV series entity in other contexts, this preview excludes detailed metadata like
/// first air dates and episode counts to minimize data transfer and improve search performance.
///
public struct TVSeriesPreview: Identifiable, Equatable, Sendable {

    /// The unique identifier for the TV series.
    public let id: Int

    /// The TV series' name.
    public let name: String

    /// A brief description or plot summary of the TV series.
    public let overview: String

    /// URL path to the TV series' poster image.
    public let posterPath: URL?

    /// URL path to the TV series' backdrop image.
    public let backdropPath: URL?

    ///
    /// Creates a new TV series preview instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the TV series.
    ///   - name: The TV series' name.
    ///   - overview: A brief description or plot summary.
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
