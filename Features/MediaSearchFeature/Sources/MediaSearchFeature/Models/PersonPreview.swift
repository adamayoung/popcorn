//
//  PersonPreview.swift
//  MediaSearchFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct PersonPreview: Identifiable, Sendable, Equatable {

    public let id: Int
    public let name: String
    public let profileURL: URL?

    public init(
        id: Int,
        name: String,
        profileURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.profileURL = profileURL
    }

}

extension PersonPreview {

    static var mocks: [PersonPreview] {
        [
            PersonPreview(
                id: 234_352,
                name: "Margot Robbie",
                profileURL: URL(
                    string: "https://image.tmdb.org/t/p/h632/euDPyqLnuwaWMHajcU3oZ9uZezR.jpg")
            ),
            PersonPreview(
                id: 2283,
                name: "Stanley Tucci",
                profileURL: URL(
                    string: "https://image.tmdb.org/t/p/h632/q4TanMDI5Rgsvw4SfyNbPBh4URr.jpg")
            )
        ]
    }

}
