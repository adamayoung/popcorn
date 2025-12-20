//
//  Genre.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct Genre: Sendable, Equatable, Identifiable {

    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

}
