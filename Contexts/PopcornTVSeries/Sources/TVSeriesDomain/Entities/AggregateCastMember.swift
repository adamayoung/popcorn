//
//  AggregateCastMember.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

///
/// Represents a cast member aggregated across all seasons of a TV series.
///
/// Each aggregate cast member may have multiple roles (characters) played
/// across different seasons and episodes.
///
public struct AggregateCastMember: Identifiable, Equatable, Sendable {

    /// The unique identifier for the person.
    public let id: Int

    /// The name of the cast member.
    public let name: String

    /// The path to the cast member's profile image.
    public let profilePath: URL?

    /// The gender of the cast member.
    public let gender: Gender

    /// The roles (characters) played by this cast member across all seasons.
    public let roles: [CastRole]

    /// The total number of episodes in which this cast member appeared.
    public let totalEpisodeCount: Int

    ///
    /// Creates a new aggregate cast member instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the person.
    ///   - name: The name of the cast member.
    ///   - profilePath: The path to the cast member's profile image.
    ///   - gender: The gender of the cast member.
    ///   - roles: The roles played across all seasons.
    ///   - totalEpisodeCount: The total number of episodes appeared in.
    ///
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

///
/// Represents a specific role (character) played by a cast member.
///
public struct CastRole: Equatable, Sendable {

    /// The unique credit identifier for this role.
    public let creditID: String

    /// The character name played in this role.
    public let character: String

    /// The number of episodes in which this role appeared.
    public let episodeCount: Int

    ///
    /// Creates a new cast role instance.
    ///
    /// - Parameters:
    ///   - creditID: The unique credit identifier.
    ///   - character: The character name.
    ///   - episodeCount: The number of episodes.
    ///
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
