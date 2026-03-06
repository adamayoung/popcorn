//
//  AggregateCreditsDetailsMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import CrewOrdering
import Foundation
import TVSeriesDomain

struct AggregateCreditsDetailsMapper {

    func map(
        _ aggregateCredits: AggregateCredits,
        imagesConfiguration: ImagesConfiguration
    ) -> AggregateCreditsDetails {
        let castMapper = AggregateCastMemberDetailsMapper()
        let crewMapper = AggregateCrewMemberDetailsMapper()

        let crewMembers = aggregateCredits.crew.map {
            crewMapper.map($0, imagesConfiguration: imagesConfiguration)
        }

        let crewByDepartment = CrewOrdering.groupedByDepartment(
            crewMembers,
            department: \.department,
            jobSortOrder: { $0.jobs.map { CrewOrdering.jobSortOrder($0.job) }.min() ?? Int.max },
            name: \.name
        ).map { AggregateCrewDepartmentGroup(department: $0.department, members: $0.members) }

        return AggregateCreditsDetails(
            id: aggregateCredits.id,
            cast: aggregateCredits.cast.map {
                castMapper.map($0, imagesConfiguration: imagesConfiguration)
            },
            crewByDepartment: crewByDepartment
        )
    }

}
