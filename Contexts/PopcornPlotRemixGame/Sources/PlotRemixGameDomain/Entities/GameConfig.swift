//
//  GameConfig.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Represents the initial configuration for creating a Plot Remix game.
///
/// This entity defines the parameters used to generate a new game session. Unlike
/// ``Game/Settings``, this configuration uses optional genre and year filters to allow
/// for flexible game creation, and uses a genre ID rather than a full ``Genre`` object
/// for efficient parameter passing during game generation.
///
public struct GameConfig: Sendable {

    /// The narrative style to use for remixing movie plots.
    public let theme: GameTheme

    /// The identifier of the genre to filter movies by, if any.
    public let genreID: Int?

    /// The release year constraints for movie selection, if any.
    public let primaryReleaseYearFilter: PrimaryReleaseYearFilter?

    ///
    /// Creates a new game configuration.
    ///
    /// - Parameters:
    ///   - theme: The narrative style for plot remixes.
    ///   - genreID: The genre filter identifier. Defaults to `nil` for no genre filtering.
    ///   - primaryReleaseYearFilter: The release year constraints. Defaults to `nil` for no year filtering.
    ///
    public init(
        theme: GameTheme,
        genreID: Int? = nil,
        primaryReleaseYearFilter: PrimaryReleaseYearFilter? = nil
    ) {
        self.theme = theme
        self.genreID = genreID
        self.primaryReleaseYearFilter = primaryReleaseYearFilter
    }

}
