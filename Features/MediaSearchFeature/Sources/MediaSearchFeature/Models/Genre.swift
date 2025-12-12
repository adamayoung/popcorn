//
//  Genre.swift
//  MediaSearchFeature
//
//  Created by Adam Young on 11/12/2025.
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

extension Genre {

    static var mocks: [Genre] {
        [
            Genre(id: 28, name: "Action"),
            Genre(id: 12, name: "Adventure"),
            Genre(id: 16, name: "Animation")
        ]
    }

}
