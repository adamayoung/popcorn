//
//  AggregateCredits.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents the aggregate credits for a TV series across all seasons.
///
/// Aggregate credits combine cast and crew appearances across every season
/// and episode, with role and job details per person.
///
public struct AggregateCredits: Identifiable, Equatable, Sendable {

    /// The unique identifier for the credits, matching the TV series identifier.
    public let id: Int

    /// The cast members appearing across all seasons of the TV series.
    public let cast: [AggregateCastMember]

    /// The crew members who worked across all seasons of the TV series.
    public let crew: [AggregateCrewMember]

    ///
    /// Creates a new aggregate credits instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the credits.
    ///   - cast: The cast members appearing across all seasons.
    ///   - crew: The crew members who worked across all seasons.
    ///
    public init(
        id: Int,
        cast: [AggregateCastMember],
        crew: [AggregateCrewMember]
    ) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
