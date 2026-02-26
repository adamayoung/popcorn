//
//  AggregateCrewMemberEntityMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

struct AggregateCrewMemberEntityMapper {

    func map(_ entity: TVSeriesAggregateCrewMemberEntity) -> AggregateCrewMember {
        let genderMapper = GenderEntityMapper()

        let jobs = entity.jobs.map { job in
            CrewJob(
                creditID: job.creditID,
                job: job.job,
                episodeCount: job.episodeCount
            )
        }

        return AggregateCrewMember(
            id: entity.personID,
            name: entity.name,
            profilePath: entity.profilePath,
            gender: genderMapper.map(entity.gender),
            department: entity.department,
            jobs: jobs,
            totalEpisodeCount: entity.totalEpisodeCount,
            initials: personInitials(from: entity.name)
        )
    }

    func map(
        _ crewMember: AggregateCrewMember,
        tvSeriesID: Int,
        order: Int
    ) -> TVSeriesAggregateCrewMemberEntity {
        let genderMapper = GenderEntityMapper()

        let jobs = crewMember.jobs.map { job in
            CrewJobValue(
                creditID: job.creditID,
                job: job.job,
                episodeCount: job.episodeCount
            )
        }

        return TVSeriesAggregateCrewMemberEntity(
            tvSeriesID: tvSeriesID,
            personID: crewMember.id,
            name: crewMember.name,
            profilePath: crewMember.profilePath,
            gender: genderMapper.map(crewMember.gender),
            department: crewMember.department,
            jobs: jobs,
            totalEpisodeCount: crewMember.totalEpisodeCount,
            order: order
        )
    }

}
