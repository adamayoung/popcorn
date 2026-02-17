//
//  CastMember.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

/// Represents ``CastMember``.
public struct CastMember: Identifiable, Equatable, Sendable {

    /// The ``id`` value.
    public let id: String
    /// The ``personID`` value.
    public let personID: Int
    /// The ``characterName`` value.
    public let characterName: String
    /// The ``personName`` value.
    public let personName: String
    /// The ``profilePath`` value.
    public let profilePath: URL?
    /// The ``gender`` value.
    public let gender: Gender
    /// The ``order`` value.
    public let order: Int

    /// Creates a new instance.
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
