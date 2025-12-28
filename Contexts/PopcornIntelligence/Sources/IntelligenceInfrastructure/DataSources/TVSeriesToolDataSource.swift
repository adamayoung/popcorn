//
//  TVSeriesToolDataSource.swift
//  PopcornIntelligence
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import FoundationModels

protocol TVSeriesToolDataSource: Sendable {

    func tvSeriesDetails() -> any Tool

}
