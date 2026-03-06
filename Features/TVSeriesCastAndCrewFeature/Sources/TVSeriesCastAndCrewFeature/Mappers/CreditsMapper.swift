//
//  CreditsMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

struct CreditsMapper {

    func map(_ aggregateCreditsDetails: AggregateCreditsDetails) -> Credits {
        Credits(
            id: aggregateCreditsDetails.id,
            castMembers: aggregateCreditsDetails.cast.map(map),
            crewByDepartment: aggregateCreditsDetails.crewByDepartment.map(map)
        )
    }

    private func map(_ castMemberDetails: AggregateCastMemberDetails) -> CastMember {
        let roles = castMemberDetails.roles.map { role in
            CastMember.Role(
                character: role.character,
                episodeCount: role.episodeCount
            )
        }

        return CastMember(
            id: castMemberDetails.id,
            personName: castMemberDetails.name,
            profileURL: castMemberDetails.profileURLSet?.detail,
            roles: roles,
            totalEpisodeCount: castMemberDetails.totalEpisodeCount,
            initials: castMemberDetails.initials
        )
    }

    private func map(_ group: AggregateCrewDepartmentGroup) -> CrewDepartment {
        CrewDepartment(
            department: group.department,
            members: group.members.map(map)
        )
    }

    private func map(_ crewMemberDetails: AggregateCrewMemberDetails) -> CrewMember {
        let jobs = crewMemberDetails.jobs.map { job in
            CrewMember.Job(
                job: job.job,
                episodeCount: job.episodeCount
            )
        }

        return CrewMember(
            id: crewMemberDetails.id,
            personName: crewMemberDetails.name,
            profileURL: crewMemberDetails.profileURLSet?.detail,
            department: crewMemberDetails.department,
            jobs: jobs,
            totalEpisodeCount: crewMemberDetails.totalEpisodeCount,
            initials: crewMemberDetails.initials
        )
    }

}
