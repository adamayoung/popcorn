//
//  Person.swift
//  PersonDetailsFeature
//
//  Created by Adam Young on 17/11/2025.
//

import Foundation

public struct Person: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let biography: String
    public let knownForDepartment: String
    public let gender: Gender
    public let profileURL: URL?

    public init(
        id: Int,
        name: String,
        biography: String,
        knownForDepartment: String,
        gender: Gender,
        profileURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.biography = biography
        self.knownForDepartment = knownForDepartment
        self.gender = gender
        self.profileURL = profileURL
    }

}
