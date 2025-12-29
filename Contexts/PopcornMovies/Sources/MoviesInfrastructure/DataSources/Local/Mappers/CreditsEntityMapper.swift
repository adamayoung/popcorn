//
//  CreditsEntityMapper.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

struct CreditsEntityMapper {

    func map(_ entity: CreditsEntity) -> Credits {
        let castMapper = CastMemberEntityMapper()
        let crewMapper = CrewMemberEntityMapper()

        let cast = entity.cast
            .map(castMapper.map)
            .sorted { $0.order < $1.order }

        let crew = entity.crew
            .map(crewMapper.map)

        return Credits(
            id: entity.movieID,
            cast: cast,
            crew: crew
        )
    }

    func compactMap(_ entity: CreditsEntity?) -> Credits? {
        guard let entity else {
            return nil
        }
        return map(entity)
    }

    func map(_ credits: Credits, movieID: Int) -> CreditsEntity {
        let castMapper = CastMemberEntityMapper()
        let crewMapper = CrewMemberEntityMapper()

        return CreditsEntity(
            movieID: movieID,
            cast: credits.cast.map { castMapper.map($0, movieID: movieID) },
            crew: credits.crew.map { crewMapper.map($0, movieID: movieID) }
        )
    }

    func map(_ credits: Credits, movieID: Int, to entity: CreditsEntity) {
        let castMapper = CastMemberEntityMapper()
        let crewMapper = CrewMemberEntityMapper()

        entity.cast = credits.cast.map { castMapper.map($0, movieID: movieID) }
        entity.crew = credits.crew.map { crewMapper.map($0, movieID: movieID) }
        entity.cachedAt = .now
    }

}
