//
//  TVSeriesToolDataSource.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import FoundationModels

public protocol TVSeriesToolDataSource: Sendable {

    func tvSeries() -> any Tool

}
