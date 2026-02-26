//
//  AggregateCastMemberDetails.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

public struct AggregateCastMemberDetails: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let profileURLSet: ImageURLSet?
    public let gender: Gender
    public let roles: [CastRoleDetails]
    public let totalEpisodeCount: Int

    public init(
        id: Int,
        name: String,
        profileURLSet: ImageURLSet? = nil,
        gender: Gender,
        roles: [CastRoleDetails],
        totalEpisodeCount: Int
    ) {
        self.id = id
        self.name = name
        self.profileURLSet = profileURLSet
        self.gender = gender
        self.roles = roles
        self.totalEpisodeCount = totalEpisodeCount
    }

}

public struct CastRoleDetails: Equatable, Sendable {

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
