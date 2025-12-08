//
//  TVSeriesPreview.swift
//  SearchKit
//
//  Created by Adam Young on 10/06/2025.
//

import Foundation

public struct TVSeriesPreview: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let overview: String
    public let posterPath: URL?
    public let backdropPath: URL?

    public init(
        id: Int,
        name: String,
        overview: String,
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
