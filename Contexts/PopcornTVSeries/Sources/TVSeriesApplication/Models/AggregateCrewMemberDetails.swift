//
//  AggregateCrewMemberDetails.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

public struct AggregateCrewMemberDetails: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let profileURLSet: ImageURLSet?
    public let gender: Gender
    public let department: String
    public let jobs: [CrewJobDetails]
    public let totalEpisodeCount: Int

    public init(
        id: Int,
        name: String,
        profileURLSet: ImageURLSet? = nil,
        gender: Gender,
        department: String,
        jobs: [CrewJobDetails],
        totalEpisodeCount: Int
    ) {
        self.id = id
        self.name = name
        self.profileURLSet = profileURLSet
        self.gender = gender
        self.department = department
        self.jobs = jobs
        self.totalEpisodeCount = totalEpisodeCount
    }

}

public struct CrewJobDetails: Equatable, Sendable {

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
