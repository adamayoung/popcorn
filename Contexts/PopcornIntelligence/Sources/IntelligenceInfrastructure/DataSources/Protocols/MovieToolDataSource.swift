//
//  MovieToolDataSource.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import FoundationModels

/// Defines the ``MovieToolDataSource`` contract.
public protocol MovieToolDataSource: Sendable {

    func movie() -> any Tool

    func movieCredits() -> any Tool

}
