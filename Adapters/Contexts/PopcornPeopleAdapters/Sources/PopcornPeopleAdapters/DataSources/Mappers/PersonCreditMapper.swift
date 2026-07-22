//
//  PersonCreditMapper.swift
//  PopcornPeopleAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PeopleDomain
import TMDb

struct PersonCreditMapper {

    func map(_ credits: TMDb.PersonCombinedCredits) -> [PersonCredit] {
        credits.cast.map(mapCast) + credits.crew.map(mapCrew)
    }

    private func mapCast(_ credit: TMDb.ShowCastCredit) -> PersonCredit {
        switch credit {
        case .movie(let movie):
            PersonCredit(
                id: movie.id,
                mediaType: .movie,
                title: movie.title,
                backdropPath: movie.backdropPath,
                posterPath: movie.posterPath,
                popularity: movie.popularity,
                role: .cast
            )

        case .tvSeries(let tvSeries):
            PersonCredit(
                id: tvSeries.id,
                mediaType: .tvSeries,
                title: tvSeries.name,
                backdropPath: tvSeries.backdropPath,
                posterPath: tvSeries.posterPath,
                popularity: tvSeries.popularity,
                role: .cast
            )
        }
    }

    private func mapCrew(_ credit: TMDb.ShowCrewCredit) -> PersonCredit {
        switch credit {
        case .movie(let movie):
            PersonCredit(
                id: movie.id,
                mediaType: .movie,
                title: movie.title,
                backdropPath: movie.backdropPath,
                posterPath: movie.posterPath,
                popularity: movie.popularity,
                role: .crew(department: movie.department)
            )

        case .tvSeries(let tvSeries):
            PersonCredit(
                id: tvSeries.id,
                mediaType: .tvSeries,
                title: tvSeries.name,
                backdropPath: tvSeries.backdropPath,
                posterPath: tvSeries.posterPath,
                popularity: tvSeries.popularity,
                role: .crew(department: tvSeries.department)
            )
        }
    }

}
