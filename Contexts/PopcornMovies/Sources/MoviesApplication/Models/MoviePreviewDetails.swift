//
//  MoviePreviewDetails.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

public struct MoviePreviewDetails: Identifiable, Equatable, Sendable {

    public let id: Int
    public let title: String
    public let overview: String
    public let posterURLSet: ImageURLSet?
    public let backdropURLSet: ImageURLSet?
    public let logoURLSet: ImageURLSet?

    public init(
        id: Int,
        title: String,
        overview: String,
        posterURLSet: ImageURLSet? = nil,
        backdropURLSet: ImageURLSet? = nil,
        logoURLSet: ImageURLSet? = nil
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterURLSet = posterURLSet
        self.backdropURLSet = backdropURLSet
        self.logoURLSet = logoURLSet
    }

}
