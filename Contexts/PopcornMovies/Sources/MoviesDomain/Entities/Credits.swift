//
//  Credits.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct Credits: Identifiable, Equatable, Sendable {

    public let id: Int
    public let cast: [CastMember]
    public let crew: [CrewMember]

    public init(
        id: Int,
        cast: [CastMember],
        crew: [CrewMember]
    ) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
