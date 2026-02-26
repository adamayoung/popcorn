//
//  AggregateCredits.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct AggregateCredits: Identifiable, Equatable, Sendable {

    public let id: Int
    public let cast: [AggregateCastMember]
    public let crew: [AggregateCrewMember]

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
