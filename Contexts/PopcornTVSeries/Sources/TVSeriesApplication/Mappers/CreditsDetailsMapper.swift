//
//  CreditsDetailsMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import CrewOrdering
import Foundation
import TVSeriesDomain

struct CreditsDetailsMapper {

    func map(
        _ credits: Credits,
        imagesConfiguration: ImagesConfiguration
    ) -> CreditsDetails {
        let castMapper = CastMemberDetailsMapper()
        let crewMapper = CrewMemberDetailsMapper()

        let crewMembers = credits.crew.map {
            crewMapper.map($0, imagesConfiguration: imagesConfiguration)
        }

        let crewByDepartment = CrewOrdering.groupedByDepartment(
            crewMembers,
            department: \.department,
            jobSortOrder: { CrewOrdering.jobSortOrder($0.job) },
            name: \.personName
        ).map { CrewDepartmentGroup(department: $0.department, members: $0.members) }

        return CreditsDetails(
            id: credits.id,
            cast: credits.cast.map { castMapper.map($0, imagesConfiguration: imagesConfiguration) },
            crewByDepartment: crewByDepartment
        )
    }

}
