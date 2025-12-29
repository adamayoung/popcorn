//
//  MovieToolDataSource.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import FoundationModels

public protocol MovieToolDataSource: Sendable {

    func movieDetails() -> any Tool

}
