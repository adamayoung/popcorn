//
//  CastMember.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct CastMember: Identifiable, Equatable, Sendable {

    public let id: String
    public let personID: Int
    public let characterName: String
    public let personName: String
    public let profileURL: URL?
    public let initials: String?

    public init(
        id: String,
        personID: Int,
        characterName: String,
        personName: String,
        profileURL: URL? = nil,
        initials: String? = nil
    ) {
        self.id = id
        self.personID = personID
        self.characterName = characterName
        self.personName = personName
        self.profileURL = profileURL
        self.initials = initials
    }

}

extension CastMember {

    static var mocks: [CastMember] {
        [
            CastMember(
                id: "5256c8b219c2956ff6047cd8",
                personID: 17419,
                characterName: "Eleven",
                personName: "Millie Bobby Brown",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/3WsZbEbqMkFb5WCkNKBqYGlOxoA.jpg")
            ),
            CastMember(
                id: "5256c8b219c2956ff6047ce4",
                personID: 37153,
                characterName: "Jim Hopper",
                personName: "David Harbour",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/chPekukMF5SNnW6b22NbYPqAR3Y.jpg")
            ),
            CastMember(
                id: "5256c8b219c2956ff6047cf0",
                personID: 1_253_360,
                characterName: "Mike Wheeler",
                personName: "Finn Wolfhard",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/8FNMCuqFNoAFwk9LEwpfEgHjXID.jpg")
            ),
            CastMember(
                id: "5256c8b219c2956ff6047cfc",
                personID: 1_253_361,
                characterName: "Dustin Henderson",
                personName: "Gaten Matarazzo",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/giYMoLmFSaQUoMkFpBMZMF9BQGK.jpg")
            )
        ]
    }

}
