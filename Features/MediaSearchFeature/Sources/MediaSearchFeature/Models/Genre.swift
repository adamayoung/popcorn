//
//  Genre.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

public struct Genre: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let color: ThemeColor
    public let backdropURL: URL?

    public init(
        id: Int,
        name: String,
        color: ThemeColor,
        backdropURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.color = color
        self.backdropURL = backdropURL
    }

}

extension Genre {

    static var mocks: [Genre] {
        [
            Genre(id: 28, name: "Action", color: ThemeColor(red: 1.0, green: 0.23, blue: 0.19)),
            Genre(id: 12, name: "Adventure", color: ThemeColor(red: 1.0, green: 0.58, blue: 0.0)),
            Genre(id: 16, name: "Animation", color: ThemeColor(red: 1.0, green: 0.8, blue: 0.0))
        ]
    }

}
