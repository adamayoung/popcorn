//
//  PersonPreview.swift
//  Popcorn
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
