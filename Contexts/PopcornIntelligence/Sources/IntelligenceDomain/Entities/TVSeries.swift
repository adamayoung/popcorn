//
//  TVSeries.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Represents a TV series in the domain model.
///
/// A TV series contains essential information including its name, overview,
/// and associated imagery paths. This is the core domain entity used throughout
/// the TV series context for representing series data.
///
public struct TVSeries: Identifiable, Equatable, Sendable {

    /// The unique identifier for the TV series.
    public let id: Int

    /// The TV series' name.
    public let name: String

    /// A brief description or summary of the TV series.
    public let overview: String?

    /// URL path to the TV series' poster image.
    public let posterPath: URL?

    /// URL path to the TV series' backdrop image.
    public let backdropPath: URL?

    ///
    /// Creates a new TV series instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the TV series.
    ///   - name: The TV series' name.
    ///   - overview: A brief description or summary. Defaults to `nil`.
    ///   - posterPath: URL path to the poster image. Defaults to `nil`.
    ///   - backdropPath: URL path to the backdrop image. Defaults to `nil`.
    ///
    public init(
        id: Int,
        name: String,
        overview: String? = nil,
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
