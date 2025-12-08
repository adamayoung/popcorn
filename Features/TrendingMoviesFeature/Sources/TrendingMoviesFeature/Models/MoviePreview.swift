//
//  MoviePreview.swift
//  TrendingMoviesFeature
//
//  Created by Adam Young on 17/11/2025.
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
