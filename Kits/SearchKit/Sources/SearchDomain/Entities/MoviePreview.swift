//
//  MoviePreview.swift
//  SearchKit
//
//  Created by Adam Young on 10/06/2025.
//

import Foundation

public struct MoviePreview: Identifiable, Equatable, Sendable {

    public let id: Int
    public let title: String
    public let overview: String
    public let posterPath: URL?
    public let backdropPath: URL?

    public init(
        id: Int,
        title: String,
        overview: String,
        posterPath: URL? = nil,
        backdropPath: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }

}
