//
//  CastMemberEntity.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SwiftData

@Model
final class CastMemberEntity: Equatable {

    @Attribute(.unique) var creditID: String
    var movieID: Int
    var personID: Int
    var characterName: String
    var personName: String
    var profilePath: URL?
    var gender: Int
    var order: Int

    init(
        creditID: String,
        movieID: Int,
        personID: Int,
        characterName: String,
        personName: String,
        profilePath: URL? = nil,
        gender: Int,
        order: Int
    ) {
        self.creditID = creditID
        self.movieID = movieID
        self.personID = personID
        self.characterName = characterName
        self.personName = personName
        self.profilePath = profilePath
        self.gender = gender
        self.order = order
    }

}
