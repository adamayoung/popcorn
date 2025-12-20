//
//  PrimaryReleaseYearFilter.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public enum PrimaryReleaseYearFilter: Equatable, Sendable {
    case onYear(Int)
    case fromYear(Int)
    case upToYear(Int)
    case betweenYears(start: Int, end: Int)
}
