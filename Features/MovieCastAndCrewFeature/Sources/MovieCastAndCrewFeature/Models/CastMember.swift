//
//  CastMember.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct CastMember: Identifiable, Equatable, Sendable {

    public let id: String
    public let personID: Int
    public let characterName: String
    public let personName: String
    public let profileURL: URL?

    public init(
        id: String,
        personID: Int,
        characterName: String,
        personName: String,
        profileURL: URL? = nil
    ) {
        self.id = id
        self.personID = personID
        self.characterName = characterName
        self.personName = personName
        self.profileURL = profileURL
    }

}

extension CastMember {

    static var mocks: [CastMember] {
        [
            CastMember(
                id: "6618282484f249014a672608",
                personID: 83271,
                characterName: "Ben Richards",
                personName: "Glen Powell",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/fUnIaJkdgvQTztyR1nLeUceSzly.jpg")
            ),
            CastMember(
                id: "67116a6429d8a59e045ed0be",
                personID: 16851,
                characterName: "Dan Killian",
                personName: "Josh Brolin",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/sX2etBbIkxRaCsATyw5ZpOVMPTD.jpg")
            ),
            CastMember(
                id: "6780104a7732209e17bb38ec",
                personID: 91671,
                characterName: "Bobby Thompson",
                personName: "Colman Domingo",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/sX2etBbIkxRaCsATyw5ZpOVMPTD.jpg")
            ),
            CastMember(
                id: "6780104a7732209e17bb38ed",
                personID: 72095,
                characterName: "Evan McCone",
                personName: "Lee Pace",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/eeTc0d2AX1vFYVxZ6Qw7qZpg4Tz.jpg")
            )
        ]
    }

}
