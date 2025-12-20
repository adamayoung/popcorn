//
//  FavouriteMovie.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct WatchlistMovie: Identifiable, Equatable, Hashable, Sendable {

    public let id: Int
    public let createdAt: Date

    public init(id: Int, createdAt: Date) {
        self.id = id
        self.createdAt = createdAt
    }

}
