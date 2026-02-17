//
//  Movie.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents a movie in the Plot Remix game context.
///
/// This entity contains the essential movie information needed for game question generation
/// and answer verification. The overview serves as the source material for plot remixing,
/// while the title and imagery are used for displaying correct answers. This is a Plot
/// Remix context-specific entity, separate from movie entities in other contexts, optimized
/// specifically for game mechanics.
///
public struct Movie: Sendable, Equatable {

    /// The unique identifier for the movie.
    public let id: Int

    /// The movie's title, used as the correct answer in questions.
    public let title: String

    /// The original plot description that will be remixed according to the game theme.
    public let overview: String

    /// URL path to the movie's poster image for result displays.
    public let posterPath: URL?

    /// URL path to the movie's backdrop image for visual presentation.
    public let backdropPath: URL?

    ///
    /// Creates a new movie instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the movie.
    ///   - title: The movie's title.
    ///   - overview: The original plot description.
    ///   - posterPath: URL path to the poster image.
    ///   - backdropPath: URL path to the backdrop image.
    ///
    public init(
        id: Int,
        title: String,
        overview: String,
        posterPath: URL?,
        backdropPath: URL?
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }

}
