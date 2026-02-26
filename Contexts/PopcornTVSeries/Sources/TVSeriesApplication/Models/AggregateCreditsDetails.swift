//
//  AggregateCreditsDetails.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct AggregateCreditsDetails: Identifiable, Equatable, Sendable {

    public let id: Int
    public let cast: [AggregateCastMemberDetails]
    public let crew: [AggregateCrewMemberDetails]

    public init(
        id: Int,
        cast: [AggregateCastMemberDetails],
        crew: [AggregateCrewMemberDetails]
    ) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
