//
//  CrewMember.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

/// Represents ``CrewMember``.
public struct CrewMember: Identifiable, Equatable, Sendable {

    /// The ``id`` value.
    public let id: String
    /// The ``personID`` value.
    public let personID: Int
    /// The ``personName`` value.
    public let personName: String
    /// The ``job`` value.
    public let job: String
    /// The ``profilePath`` value.
    public let profilePath: URL?
    /// The ``gender`` value.
    public let gender: Gender
    /// The ``department`` value.
    public let department: String

    /// Creates a new instance.
    public init(
        id: String,
        personID: Int,
        personName: String,
        job: String,
        profilePath: URL? = nil,
        gender: Gender,
        department: String
    ) {
        self.id = id
        self.personID = personID
        self.personName = personName
        self.job = job
        self.profilePath = profilePath
        self.gender = gender
        self.department = department
    }

}
