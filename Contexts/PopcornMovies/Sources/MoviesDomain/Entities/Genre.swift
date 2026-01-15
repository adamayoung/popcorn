//
//  Genre.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct Genre: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

}
