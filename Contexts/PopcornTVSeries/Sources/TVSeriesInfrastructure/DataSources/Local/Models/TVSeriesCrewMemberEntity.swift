//
//  TVSeriesCrewMemberEntity.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class TVSeriesCrewMemberEntity: Equatable {

    @Attribute(.unique) var creditID: String
    var tvSeriesID: Int
    var personID: Int
    var personName: String
    var job: String
    var profilePath: URL?
    var gender: Int
    var department: String

    init(
        creditID: String,
        tvSeriesID: Int,
        personID: Int,
        personName: String,
        job: String,
        profilePath: URL? = nil,
        gender: Int,
        department: String
    ) {
        self.creditID = creditID
        self.tvSeriesID = tvSeriesID
        self.personID = personID
        self.personName = personName
        self.job = job
        self.profilePath = profilePath
        self.gender = gender
        self.department = department
    }

}
