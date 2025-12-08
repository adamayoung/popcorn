//
//  FavouriteMovie.swift
//  MoviesKit
//
//  Created by Adam Young on 03/12/2025.
//

import Foundation

public struct FavouriteMovie: Identifiable, Equatable, Hashable, Sendable {

    public let id: Int
    public let createdAt: Date

    public init(id: Int, createdAt: Date) {
        self.id = id
        self.createdAt = createdAt
    }

}
