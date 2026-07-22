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
                releaseDate: movie.releaseDate,
                role: .cast(character: Self.character(movie.character))
            )

        case .tvSeries(let tvSeries):
            PersonCredit(
                id: tvSeries.id,
                mediaType: .tvSeries,
                title: tvSeries.name,
                backdropPath: tvSeries.backdropPath,
                posterPath: tvSeries.posterPath,
                popularity: tvSeries.popularity,
                releaseDate: tvSeries.firstAirDate,
                role: .cast(character: Self.character(tvSeries.character))
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
                releaseDate: movie.releaseDate,
                role: .crew(job: movie.job, department: movie.department)
            )

        case .tvSeries(let tvSeries):
            PersonCredit(
                id: tvSeries.id,
                mediaType: .tvSeries,
                title: tvSeries.name,
                backdropPath: tvSeries.backdropPath,
                posterPath: tvSeries.posterPath,
                popularity: tvSeries.popularity,
                releaseDate: tvSeries.firstAirDate,
                role: .crew(job: tvSeries.job, department: tvSeries.department)
            )
        }
    }

    /// TMDb reports an unknown character as an empty string; normalise it to `nil`.
    private static func character(_ character: String) -> String? {
        character.isEmpty ? nil : character
    }

}
