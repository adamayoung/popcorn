//
//  AggregateCreditsDetailsMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

struct AggregateCreditsDetailsMapper {

    func map(
        _ aggregateCredits: AggregateCredits,
        imagesConfiguration: ImagesConfiguration
    ) -> AggregateCreditsDetails {
        let castMapper = AggregateCastMemberDetailsMapper()
        let crewMapper = AggregateCrewMemberDetailsMapper()

        return AggregateCreditsDetails(
            id: aggregateCredits.id,
            cast: aggregateCredits.cast.map {
                castMapper.map($0, imagesConfiguration: imagesConfiguration)
            },
            crew: aggregateCredits.crew.map {
                crewMapper.map($0, imagesConfiguration: imagesConfiguration)
            }
        )
    }

}
