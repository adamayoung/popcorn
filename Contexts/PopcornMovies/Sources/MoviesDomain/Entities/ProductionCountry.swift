//
//  ProductionCountry.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct ProductionCountry: Equatable, Sendable {

    public let countryCode: String
    public let name: String

    public init(countryCode: String, name: String) {
        self.countryCode = countryCode
        self.name = name
    }

}
