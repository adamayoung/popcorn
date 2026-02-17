//
//  CreditsEntity.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class CreditsEntity: Equatable, Identifiable, ModelExpirable {

    @Attribute(.unique) var movieID: Int
    @Relationship(deleteRule: .cascade) var cast: [CastMemberEntity]
    @Relationship(deleteRule: .cascade) var crew: [CrewMemberEntity]
    var cachedAt: Date

    init(
        movieID: Int,
        cast: [CastMemberEntity] = [],
        crew: [CrewMemberEntity] = [],
        cachedAt: Date = Date.now
    ) {
        self.movieID = movieID
        self.cast = cast
        self.crew = crew
        self.cachedAt = cachedAt
    }

}
