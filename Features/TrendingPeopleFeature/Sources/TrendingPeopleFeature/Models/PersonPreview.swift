//
//  PersonPreview.swift
//  TrendingPeopleFeature
//
//  Created by Adam Young on 19/11/2025.
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
