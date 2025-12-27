//
//  TVSeries.swift
//  TVSeriesIntelligenceFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct TVSeries: Identifiable, Sendable {

    public let id: Int
    public let name: String
    public let tagline: String?

    public init(
        id: Int,
        name: String,
        tagline: String? = nil
    ) {
        self.id = id
        self.name = name
        self.tagline = tagline
    }

}
