//
//  CrewMember.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

public struct CrewMember: Identifiable, Equatable, Sendable {

    public let id: String
    public let personID: Int
    public let personName: String
    public let job: String
    public let profilePath: URL?
    public let gender: Gender
    public let department: String

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
