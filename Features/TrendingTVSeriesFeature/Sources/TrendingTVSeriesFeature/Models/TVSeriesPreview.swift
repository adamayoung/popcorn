//
//  TVSeriesPreview.swift
//  TrendingTVSeriesFeature
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
