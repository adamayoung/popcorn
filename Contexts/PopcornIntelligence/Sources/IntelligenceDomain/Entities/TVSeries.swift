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
/// Represents ``TVSeries``.
public struct TVSeries: Identifiable, Equatable, Sendable {

    /// The unique identifier for the TV series.
    /// The ``id`` value.
    public let id: Int

    /// The TV series' name.
    /// The ``name`` value.
    public let name: String

    /// The ``tagline`` value.
    public let tagline: String?

    /// A brief description or summary of the TV series.
    /// The ``overview`` value.
    public let overview: String

    /// The ``numberOfSeasons`` value.
    public let numberOfSeasons: Int

    /// URL path to the TV series' poster image.
    /// The ``posterPath`` value.
    public let posterPath: URL?

    /// URL path to the TV series' backdrop image.
    /// The ``backdropPath`` value.
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
    /// Creates a new instance.
    public init(
        id: Int,
        name: String,
        tagline: String? = nil,
        overview: String,
        numberOfSeasons: Int,
        posterPath: URL? = nil,
        backdropPath: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.tagline = tagline
        self.overview = overview
        self.numberOfSeasons = numberOfSeasons
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }

}
