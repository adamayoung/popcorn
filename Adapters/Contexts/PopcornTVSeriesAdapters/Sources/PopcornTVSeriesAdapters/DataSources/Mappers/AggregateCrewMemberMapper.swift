//
//  AggregateCrewMemberMapper.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb
import TVSeriesDomain

struct AggregateCrewMemberMapper {

    func map(_ dto: TMDb.AggregateCrewMember) -> TVSeriesDomain.AggregateCrewMember {
        let genderMapper = GenderMapper()

        let jobs = dto.jobs.map { job in
            TVSeriesDomain.CrewJob(
                creditID: job.creditID,
                job: job.job,
                episodeCount: job.episodeCount
            )
        }

        return TVSeriesDomain.AggregateCrewMember(
            id: dto.id,
            name: dto.name,
            profilePath: dto.profilePath,
            gender: genderMapper.compactMap(dto.gender) ?? .unknown,
            department: dto.knownForDepartment ?? "",
            jobs: jobs,
            totalEpisodeCount: dto.totalEpisodeCount
        )
    }

}
