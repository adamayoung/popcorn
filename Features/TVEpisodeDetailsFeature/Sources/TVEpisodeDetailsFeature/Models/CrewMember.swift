//
//  CrewMember.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct CrewMember: Identifiable, Equatable, Sendable {

    public let id: String
    public let personID: Int
    public let personName: String
    public let job: String
    public let department: String
    public let profileURL: URL?
    public let initials: String?

    public init(
        id: String,
        personID: Int,
        personName: String,
        job: String,
        department: String,
        profileURL: URL? = nil,
        initials: String? = nil
    ) {
        self.id = id
        self.personID = personID
        self.personName = personName
        self.job = job
        self.department = department
        self.profileURL = profileURL
        self.initials = initials
    }

}

extension CrewMember {

    static var mocks: [CrewMember] {
        [
            CrewMember(
                id: "crew-1",
                personID: 1_222_585,
                personName: "Matt Duffer",
                job: "Director",
                department: "Directing",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/kXO5CnSxOmB1lFEBrfNUMi3cRzJ.jpg")
            ),
            CrewMember(
                id: "crew-2",
                personID: 1_222_586,
                personName: "Ross Duffer",
                job: "Writer",
                department: "Writing",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/qOEJczKPFmMKMFBEGJAdN2v8LMR.jpg")
            )
        ]
    }

}
