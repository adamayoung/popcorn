//
//  PrimaryReleaseYearFilter.swift
//  PopcornPlotRemixGame
//
//  Created by Adam Young on 10/12/2025.
//

import Foundation

public enum PrimaryReleaseYearFilter: Equatable, Sendable {
    case onYear(Int)
    case fromYear(Int)
    case upToYear(Int)
    case betweenYears(start: Int, end: Int)
}
