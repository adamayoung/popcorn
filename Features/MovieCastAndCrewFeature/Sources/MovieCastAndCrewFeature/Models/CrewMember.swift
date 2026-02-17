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
        [
            CrewMember(
                id: "663bd2bf8e73c3014b98ddca",
                personID: 17825,
                personName: "Edgar Wright",
                job: "Director",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/8j12n1FS91Lj0cyK9uhPnpXLEZT.jpg"),
                department: "Directing"
            ),
            CrewMember(
                id: "663bd2bf8e73c3014b98ddcb",
                personID: 17825,
                personName: "Edgar Wright",
                job: "Screenplay",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/8j12n1FS91Lj0cyK9uhPnpXLEZT.jpg"),
                department: "Writing"
            ),
            CrewMember(
                id: "663bd2bf8e73c3014b98ddcc",
                personID: 7624,
                personName: "Mary Parent",
                job: "Producer",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/8dpKqjQreKsz7O4xFJZYgDvhETn.jpg"),
                department: "Production"
            )
        ]
    }

}
