//
//  Genre.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

public struct Genre: Identifiable, Sendable, Equatable, Hashable {

    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

}
