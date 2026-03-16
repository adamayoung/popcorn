//
//  WatchProvider.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct WatchProvider: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let logoPath: URL?

    public init(
        id: Int,
        name: String,
        logoPath: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.logoPath = logoPath
    }

}
