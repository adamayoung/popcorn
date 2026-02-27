//
//  AggregateCredits+Mocks.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

extension AggregateCredits {

    static func mock(
        id: Int = 1396,
        cast: [AggregateCastMember] = [],
        crew: [AggregateCrewMember] = []
    ) -> AggregateCredits {
        AggregateCredits(
            id: id,
            cast: cast,
            crew: crew
        )
    }

}
