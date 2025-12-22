//
//  PrimaryReleaseYearFilter.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines release year constraints for filtering movies in Plot Remix games.
///
/// This filter allows players to customize game difficulty and nostalgia by constraining
/// which movies can appear in questions based on their theatrical release year. Multiple
/// filter strategies are supported to accommodate different player preferences and
/// knowledge bases.
///
public enum PrimaryReleaseYearFilter: Equatable, Sendable {

    /// Include only movies released in a specific year.
    case onYear(Int)

    /// Include only movies released in or after a specific year.
    case fromYear(Int)

    /// Include only movies released up to and including a specific year.
    case upToYear(Int)

    /// Include only movies released within a specific year range (inclusive).
    case betweenYears(start: Int, end: Int)

}
