//
//  CastMember.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

public struct CastMember: Identifiable, Equatable, Sendable {

    public let id: String
    public let personID: Int
    public let characterName: String
    public let personName: String
    public let profilePath: URL?
    public let gender: Gender
    public let order: Int

    public init(
        id: String,
        personID: Int,
        characterName: String,
        personName: String,
        profilePath: URL? = nil,
        gender: Gender,
        order: Int
    ) {
        self.id = id
        self.personID = personID
        self.characterName = characterName
        self.personName = personName
        self.profilePath = profilePath
        self.gender = gender
        self.order = order
    }

}
