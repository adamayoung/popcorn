//
//  CrewMember.swift
//  MovieDetailsFeature
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
    public let profileURL: URL?
    public let department: String

    public init(
        id: String,
        personID: Int,
        personName: String,
        job: String,
        profileURL: URL? = nil,
        department: String
    ) {
        self.id = id
        self.personID = personID
        self.personName = personName
        self.job = job
        self.profileURL = profileURL
        self.department = department
    }

}

extension CrewMember {

    static var mocks: [CrewMember] {
        []
    }

}
