//
//  CreditsDetails.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct CreditsDetails: Identifiable, Equatable, Sendable {

    public let id: Int
    public let cast: [CastMemberDetails]
    public let crew: [CrewMemberDetails]

    public init(
        id: Int,
        cast: [CastMemberDetails],
        crew: [CrewMemberDetails]
    ) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
