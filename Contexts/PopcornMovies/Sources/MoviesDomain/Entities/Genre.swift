//
//  Genre.swift
//  PopcornMovies
//
//  Created by Adam Young on 15/01/2026.
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
