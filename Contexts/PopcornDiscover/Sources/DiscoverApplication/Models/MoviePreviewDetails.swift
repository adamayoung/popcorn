//
//  MoviePreviewDetails.swift
//  PopcornDiscover
//
//  Created by Adam Young on 20/11/2025.
//

import CoreDomain
import DiscoverDomain
import Foundation

public struct MoviePreviewDetails: Identifiable, Equatable, Sendable {

    public let id: Int
    public let title: String
    public let overview: String
    public let releaseDate: Date
    public let genres: [Genre]
    public let posterURLSet: ImageURLSet?
    public let backdropURLSet: ImageURLSet?
    public let logoURLSet: ImageURLSet?

    public init(
        id: Int,
        title: String,
        overview: String,
        releaseDate: Date,
        genres: [Genre],
        posterURLSet: ImageURLSet? = nil,
        backdropURLSet: ImageURLSet? = nil,
        logoURLSet: ImageURLSet? = nil
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.genres = genres
        self.posterURLSet = posterURLSet
        self.backdropURLSet = backdropURLSet
        self.logoURLSet = logoURLSet
    }

}
