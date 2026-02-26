//
//  AggregateCastMember.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

public struct AggregateCastMember: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let profilePath: URL?
    public let gender: Gender
    public let roles: [CastRole]
    public let totalEpisodeCount: Int

    public init(
        id: Int,
        name: String,
        profilePath: URL?,
        gender: Gender,
        roles: [CastRole],
        totalEpisodeCount: Int
    ) {
        self.id = id
        self.name = name
        self.profilePath = profilePath
        self.gender = gender
        self.roles = roles
        self.totalEpisodeCount = totalEpisodeCount
    }

}

public struct CastRole: Equatable, Sendable {

    public let creditID: String
    public let character: String
    public let episodeCount: Int

    public init(
        creditID: String,
        character: String,
        episodeCount: Int
    ) {
        self.creditID = creditID
        self.character = character
        self.episodeCount = episodeCount
    }

}
