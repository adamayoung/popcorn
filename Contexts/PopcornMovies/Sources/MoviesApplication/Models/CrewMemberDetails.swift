//
//  CrewMemberDetails.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

public struct CrewMemberDetails: Identifiable, Equatable, Sendable {

    public let id: String
    public let personID: Int
    public let personName: String
    public let job: String
    public let profileURLSet: ImageURLSet?
    public let gender: Gender
    public let department: String
    public let initials: String?

    public init(
        id: String,
        personID: Int,
        personName: String,
        job: String,
        profileURLSet: ImageURLSet? = nil,
        gender: Gender,
        department: String,
        initials: String? = nil
    ) {
        self.id = id
        self.personID = personID
        self.personName = personName
        self.job = job
        self.profileURLSet = profileURLSet
        self.gender = gender
        self.department = department
        self.initials = initials
    }

}
