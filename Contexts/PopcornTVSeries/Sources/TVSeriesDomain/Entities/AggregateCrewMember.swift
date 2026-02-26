//
//  AggregateCrewMember.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

public struct AggregateCrewMember: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let profilePath: URL?
    public let gender: Gender
    public let department: String
    public let jobs: [CrewJob]
    public let totalEpisodeCount: Int

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

public struct CrewJob: Equatable, Sendable {

    public let creditID: String
    public let job: String
    public let episodeCount: Int

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
