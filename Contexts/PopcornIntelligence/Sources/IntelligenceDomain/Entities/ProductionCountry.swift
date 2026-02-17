//
//  ProductionCountry.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

public struct ProductionCountry: Equatable, Sendable {

    public let countryCode: String
    public let name: String

    public init(countryCode: String, name: String) {
        self.countryCode = countryCode
        self.name = name
    }

}
