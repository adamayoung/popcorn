//
//  CastMember.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct CastMember: Identifiable, Equatable, Sendable {

    public let id: Int
    public let personName: String
    public let profileURL: URL?
    public let roles: [Role]
    public let totalEpisodeCount: Int
    public let initials: String?

    public init(
        id: Int,
        personName: String,
        profileURL: URL? = nil,
        roles: [Role] = [],
        totalEpisodeCount: Int = 0,
        initials: String? = nil
    ) {
        self.id = id
        self.personName = personName
        self.profileURL = profileURL
        self.roles = roles
        self.totalEpisodeCount = totalEpisodeCount
        self.initials = initials
    }

    public struct Role: Equatable, Sendable {

        public let character: String
        public let episodeCount: Int

        public init(character: String, episodeCount: Int) {
            self.character = character
            self.episodeCount = episodeCount
        }

    }

}

extension CastMember {

    static var mocks: [CastMember] {
        [
            CastMember(
                id: 17419,
                personName: "Millie Bobby Brown",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/3WsZbEbqMkFb5WCkNKBqYGlOxoA.jpg"),
                roles: [Role(character: "Eleven", episodeCount: 34)],
                totalEpisodeCount: 34
            ),
            CastMember(
                id: 37153,
                personName: "David Harbour",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/chPekukMF5SNnW6b22NbYPqAR3Y.jpg"),
                roles: [Role(character: "Jim Hopper", episodeCount: 33)],
                totalEpisodeCount: 33
            ),
            CastMember(
                id: 1_253_360,
                personName: "Finn Wolfhard",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/8FNMCuqFNoAFwk9LEwpfEgHjXID.jpg"),
                roles: [Role(character: "Mike Wheeler", episodeCount: 33)],
                totalEpisodeCount: 33
            ),
            CastMember(
                id: 1_253_361,
                personName: "Gaten Matarazzo",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/giYMoLmFSaQUoMkFpBMZMF9BQGK.jpg"),
                roles: [Role(character: "Dustin Henderson", episodeCount: 33)],
                totalEpisodeCount: 33
            )
        ]
    }

}
