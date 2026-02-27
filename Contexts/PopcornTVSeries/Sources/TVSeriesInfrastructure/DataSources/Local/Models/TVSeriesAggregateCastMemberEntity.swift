//
//  TVSeriesAggregateCastMemberEntity.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class TVSeriesAggregateCastMemberEntity: Equatable {

    var tvSeriesID: Int
    var personID: Int
    var name: String
    var profilePath: URL?
    var gender: Int
    var roles: [CastRoleValue]
    var totalEpisodeCount: Int
    var order: Int

    init(
        tvSeriesID: Int,
        personID: Int,
        name: String,
        profilePath: URL? = nil,
        gender: Int,
        roles: [CastRoleValue] = [],
        totalEpisodeCount: Int,
        order: Int
    ) {
        self.tvSeriesID = tvSeriesID
        self.personID = personID
        self.name = name
        self.profilePath = profilePath
        self.gender = gender
        self.roles = roles
        self.totalEpisodeCount = totalEpisodeCount
        self.order = order
    }

}

struct CastRoleValue: Codable, Equatable, Sendable {

    let creditID: String
    let character: String
    let episodeCount: Int

}
