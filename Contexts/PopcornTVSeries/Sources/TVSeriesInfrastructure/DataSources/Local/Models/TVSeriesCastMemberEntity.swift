//
//  TVSeriesCastMemberEntity.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class TVSeriesCastMemberEntity: Equatable {

    @Attribute(.unique) var creditID: String
    var tvSeriesID: Int
    var personID: Int
    var characterName: String
    var personName: String
    var profilePath: URL?
    var gender: Int
    var order: Int

    init(
        creditID: String,
        tvSeriesID: Int,
        personID: Int,
        characterName: String,
        personName: String,
        profilePath: URL? = nil,
        gender: Int,
        order: Int
    ) {
        self.creditID = creditID
        self.tvSeriesID = tvSeriesID
        self.personID = personID
        self.characterName = characterName
        self.personName = personName
        self.profilePath = profilePath
        self.gender = gender
        self.order = order
    }

}
