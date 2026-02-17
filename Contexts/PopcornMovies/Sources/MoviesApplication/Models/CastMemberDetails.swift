//
//  CastMemberDetails.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

public struct CastMemberDetails: Identifiable, Equatable, Sendable {

    public let id: String
    public let personID: Int
    public let characterName: String
    public let personName: String
    public let profileURLSet: ImageURLSet?
    public let gender: Gender
    public let order: Int

    public init(
        id: String,
        personID: Int,
        characterName: String,
        personName: String,
        profileURLSet: ImageURLSet? = nil,
        gender: Gender,
        order: Int
    ) {
        self.id = id
        self.personID = personID
        self.characterName = characterName
        self.personName = personName
        self.profileURLSet = profileURLSet
        self.gender = gender
        self.order = order
    }

}
