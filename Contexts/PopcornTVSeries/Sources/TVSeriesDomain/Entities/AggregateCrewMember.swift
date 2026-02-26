//
//  AggregateCrewMember.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

///
/// Represents a crew member aggregated across all seasons of a TV series.
///
/// Each aggregate crew member may have multiple jobs (roles) performed
/// across different seasons and episodes.
///
public struct AggregateCrewMember: Identifiable, Equatable, Sendable {

    /// The unique identifier for the person.
    public let id: Int

    /// The name of the crew member.
    public let name: String

    /// The path to the crew member's profile image.
    public let profilePath: URL?

    /// The gender of the crew member.
    public let gender: Gender

    /// The department the crew member is known for.
    public let department: String

    /// The jobs performed by this crew member across all seasons.
    public let jobs: [CrewJob]

    /// The total number of episodes in which this crew member participated.
    public let totalEpisodeCount: Int

    ///
    /// Creates a new aggregate crew member instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the person.
    ///   - name: The name of the crew member.
    ///   - profilePath: The path to the crew member's profile image.
    ///   - gender: The gender of the crew member.
    ///   - department: The department the crew member is known for.
    ///   - jobs: The jobs performed across all seasons.
    ///   - totalEpisodeCount: The total number of episodes participated in.
    ///
    public init(
        id: Int,
        name: String,
        profilePath: URL?,
        gender: Gender,
        department: String,
        jobs: [CrewJob],
        totalEpisodeCount: Int
    ) {
        self.id = id
        self.name = name
        self.profilePath = profilePath
        self.gender = gender
        self.department = department
        self.jobs = jobs
        self.totalEpisodeCount = totalEpisodeCount
    }

}

///
/// Represents a specific job performed by a crew member.
///
public struct CrewJob: Equatable, Sendable {

    /// The unique credit identifier for this job.
    public let creditID: String

    /// The job title.
    public let job: String

    /// The number of episodes in which this job was performed.
    public let episodeCount: Int

    ///
    /// Creates a new crew job instance.
    ///
    /// - Parameters:
    ///   - creditID: The unique credit identifier.
    ///   - job: The job title.
    ///   - episodeCount: The number of episodes.
    ///
    public init(
        creditID: String,
        job: String,
        episodeCount: Int
    ) {
        self.creditID = creditID
        self.job = job
        self.episodeCount = episodeCount
    }

}
