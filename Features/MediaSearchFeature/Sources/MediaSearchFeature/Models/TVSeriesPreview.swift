//
//  TVSeriesPreview.swift
//  MediaSearchFeature
//
//  Created by Adam Young on 18/11/2025.
//

import Foundation

public struct TVSeriesPreview: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let posterURL: URL?

    public init(
        id: Int,
        name: String,
        posterURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.posterURL = posterURL
    }

}

extension TVSeriesPreview {

    static var mocks: [TVSeriesPreview] {
        [
            TVSeriesPreview(
                id: 225171,
                name: "Pluribus",
                posterURL: URL(
                    string: "https://image.tmdb.org/t/p/w780/nrM2xFUfKJJEmZzd5d7kohT2G0C.jpg")
            ),
            TVSeriesPreview(
                id: 66732,
                name: "Stranger Things",
                posterURL: URL(
                    string: "https://image.tmdb.org/t/p/w780/cVxVGwHce6xnW8UaVUggaPXbmoE.jpg"),
            )
        ]
    }

}
