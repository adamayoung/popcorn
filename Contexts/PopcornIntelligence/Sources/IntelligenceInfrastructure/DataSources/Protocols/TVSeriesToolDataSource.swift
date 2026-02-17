//
//  TVSeriesToolDataSource.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import FoundationModels

/// Defines the ``TVSeriesToolDataSource`` contract.
public protocol TVSeriesToolDataSource: Sendable {

    func tvSeries() -> any Tool

}
