//
//  AggregateCrewMemberDetailsMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

struct AggregateCrewMemberDetailsMapper {

    func map(
        _ crewMember: AggregateCrewMember,
        imagesConfiguration: ImagesConfiguration
    ) -> AggregateCrewMemberDetails {
        let profileURLSet = imagesConfiguration.profileURLSet(for: crewMember.profilePath)

        let jobs = crewMember.jobs.map { job in
            CrewJobDetails(
                creditID: job.creditID,
                job: job.job,
                episodeCount: job.episodeCount
            )
        }

        return AggregateCrewMemberDetails(
            id: crewMember.id,
            name: crewMember.name,
            profileURLSet: profileURLSet,
            gender: crewMember.gender,
            department: crewMember.department,
            jobs: jobs,
            totalEpisodeCount: crewMember.totalEpisodeCount
        )
    }

}
