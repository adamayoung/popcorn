//
//  CrewMember.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct CrewMember: Identifiable, Equatable, Sendable {

    public let id: Int
    public let personName: String
    public let profileURL: URL?
    public let department: String
    public let jobs: [Job]
    public let totalEpisodeCount: Int
    public let initials: String?

    public init(
        id: Int,
        personName: String,
        profileURL: URL? = nil,
        department: String,
        jobs: [Job] = [],
        totalEpisodeCount: Int = 0,
        initials: String? = nil
    ) {
        self.id = id
        self.personName = personName
        self.profileURL = profileURL
        self.department = department
        self.jobs = jobs
        self.totalEpisodeCount = totalEpisodeCount
        self.initials = initials
    }

    public struct Job: Equatable, Sendable {

        public let job: String
        public let episodeCount: Int

        public init(job: String, episodeCount: Int) {
            self.job = job
            self.episodeCount = episodeCount
        }

    }

}

extension CrewMember {

    static var mocks: [CrewMember] {
        [
            CrewMember(
                id: 1_222_585,
                personName: "Matt Duffer",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/kXO5CnSxOmB1lFEBrfNUMi3cRzJ.jpg"),
                department: "Production",
                jobs: [Job(job: "Creator", episodeCount: 34)],
                totalEpisodeCount: 34
            ),
            CrewMember(
                id: 1_222_586,
                personName: "Ross Duffer",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/qOEJczKPFmMKMFBEGJAdN2v8LMR.jpg"),
                department: "Production",
                jobs: [Job(job: "Creator", episodeCount: 34)],
                totalEpisodeCount: 34
            ),
            CrewMember(
                id: 111_581,
                personName: "Shawn Levy",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/j1CXZgmfBMjJzOnnGQOYP4m0hNq.jpg"),
                department: "Production",
                jobs: [
                    Job(job: "Executive Producer", episodeCount: 34),
                    Job(job: "Director", episodeCount: 6)
                ],
                totalEpisodeCount: 34
            )
        ]
    }

}
