//
//  MovieToolDataSource.swift
//  PopcornIntelligence
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import FoundationModels

protocol MovieToolDataSource: Sendable {

    func movieDetails() -> any Tool

}
