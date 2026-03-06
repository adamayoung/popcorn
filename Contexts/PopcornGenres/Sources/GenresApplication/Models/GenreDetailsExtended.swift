//
//  GenreDetailsExtended.swift
//  PopcornGenres
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

public struct GenreDetailsExtended: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let color: ThemeColor
    public let backdropURLSet: ImageURLSet?

    public init(
        id: Int,
        name: String,
        color: ThemeColor,
        backdropURLSet: ImageURLSet? = nil
    ) {
        self.id = id
        self.name = name
        self.color = color
        self.backdropURLSet = backdropURLSet
    }

}
