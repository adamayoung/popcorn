//
//  TVSeries.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct TVSeries: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let overview: String?
    public let posterPath: URL?
    public let backdropPath: URL?

    public init(
        id: Int,
        name: String,
        overview: String? = nil,
        posterPath: URL? = nil,
        backdropPath: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }

}
