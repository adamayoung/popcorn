//
//  Movie.swift
//  MovieIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct Movie: Identifiable, Sendable {

    public let id: Int
    public let title: String

    public init(
        id: Int,
        title: String
    ) {
        self.id = id
        self.title = title
    }

}
