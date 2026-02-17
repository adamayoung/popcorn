//
//  ProductionCompany.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

public struct ProductionCompany: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let originCountry: String

    public init(id: Int, name: String, originCountry: String) {
        self.id = id
        self.name = name
        self.originCountry = originCountry
    }

}
