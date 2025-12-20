//
//  MoviePreview.swift
//  TrendingMoviesFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct MoviePreview: Identifiable, Sendable, Equatable, Hashable {

    public let id: Int
    public let title: String
    public let posterURL: URL?

    public init(
        id: Int,
        title: String,
        posterURL: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.posterURL = posterURL
    }

}
