//
//  Credits.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents the credits for a TV series in the domain model.
///
/// Credits contain the cast and crew members associated with a TV series,
/// identified by the TV series' unique identifier.
///
public struct Credits: Identifiable, Equatable, Sendable {

    /// The unique identifier for the credits, matching the TV series identifier.
    public let id: Int

    /// The cast members appearing in the TV series.
    public let cast: [CastMember]

    /// The crew members who worked on the TV series.
    public let crew: [CrewMember]

    ///
    /// Creates a new credits instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the credits.
    ///   - cast: The cast members appearing in the TV series.
    ///   - crew: The crew members who worked on the TV series.
    ///
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
