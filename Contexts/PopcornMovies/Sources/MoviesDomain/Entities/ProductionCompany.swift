//
//  ProductionCompany.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct ProductionCompany: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let originCountry: String
    public let logoPath: URL?

    public init(id: Int, name: String, originCountry: String, logoPath: URL? = nil) {
        self.id = id
        self.name = name
        self.originCountry = originCountry
        self.logoPath = logoPath
    }

}
