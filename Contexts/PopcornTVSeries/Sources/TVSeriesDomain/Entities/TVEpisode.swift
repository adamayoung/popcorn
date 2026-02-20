//
//  TVEpisode.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents a single episode within a TV series season.
///
/// A `TVEpisode` contains the metadata for an individual episode, including
/// its name, number within the season, optional overview, air date, runtime,
/// and still image path.
///
public struct TVEpisode: Identifiable, Equatable, Sendable {

    /// The unique identifier for the episode.
    public let id: Int

    /// The episode's name.
    public let name: String

    /// The episode's number within its season.
    public let episodeNumber: Int

    /// The season number this episode belongs to.
    public let seasonNumber: Int

    /// A brief description or summary of the episode, if available.
    public let overview: String?

    /// The date the episode first aired, if available.
    public let airDate: Date?

    /// The runtime of the episode in minutes, if available.
    public let runtime: Int?

    /// URL path to the episode's still image, if available.
    public let stillPath: URL?

    ///
    /// Creates a new TV episode instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the episode.
    ///   - name: The episode's name.
    ///   - episodeNumber: The episode's number within its season.
    ///   - seasonNumber: The season number this episode belongs to.
    ///   - overview: A brief description or summary. Defaults to `nil`.
    ///   - airDate: The date the episode first aired. Defaults to `nil`.
    ///   - runtime: The runtime in minutes. Defaults to `nil`.
    ///   - stillPath: URL path to the still image. Defaults to `nil`.
    ///
    public init(
        id: Int,
        name: String,
        episodeNumber: Int,
        seasonNumber: Int,
        overview: String? = nil,
        airDate: Date? = nil,
        runtime: Int? = nil,
        stillPath: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.episodeNumber = episodeNumber
        self.seasonNumber = seasonNumber
        self.overview = overview
        self.airDate = airDate
        self.runtime = runtime
        self.stillPath = stillPath
    }

}
