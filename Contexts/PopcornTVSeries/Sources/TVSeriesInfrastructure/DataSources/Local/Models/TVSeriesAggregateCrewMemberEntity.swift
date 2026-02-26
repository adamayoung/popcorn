//
//  TVSeriesAggregateCrewMemberEntity.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class TVSeriesAggregateCrewMemberEntity: Equatable {

    var tvSeriesID: Int
    var personID: Int
    var name: String
    var profilePath: URL?
    var gender: Int
    var department: String
    var jobs: [CrewJobValue]
    var totalEpisodeCount: Int

    init(
        tvSeriesID: Int,
        personID: Int,
        name: String,
        profilePath: URL? = nil,
        gender: Int,
        department: String,
        jobs: [CrewJobValue] = [],
        totalEpisodeCount: Int
    ) {
        self.tvSeriesID = tvSeriesID
        self.personID = personID
        self.name = name
        self.profilePath = profilePath
        self.gender = gender
        self.department = department
        self.jobs = jobs
        self.totalEpisodeCount = totalEpisodeCount
    }

}

struct CrewJobValue: Codable, Equatable, Sendable {

    let creditID: String
    let job: String
    let episodeCount: Int

}
