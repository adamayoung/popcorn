//
//  TMDbDiscoverMovieFilterMapper.swift
//  PopcornDiscoverAdapters
//
//  Created by Adam Young on 08/12/2025.
//

import DiscoverDomain
import Foundation
import TMDb

struct TMDbDiscoverMovieFilterMapper {

    func compactMap(_ dto: MovieFilter?) -> TMDb.DiscoverMovieFilter? {
        guard let dto else { return nil }

        return DiscoverMovieFilter(
            originalLanguage: dto.originalLanguage,
            genres: dto.genres,
            primaryReleaseYear: compactMap(dto.primaryReleaseYear)
        )
    }

}

extension TMDbDiscoverMovieFilterMapper {

    private func compactMap(
        _ dto: MovieFilter.PrimaryReleaseYearFilter?
    ) -> TMDb.DiscoverMovieFilter.PrimaryReleaseYearFilter? {
        guard let dto else { return nil }

        switch dto {
        case .onYear(let year): return .on(year)
        case .fromYear(let year): return .from(year)
        case .upToYear(let year): return .upTo(year)
        case .betweenYears(let start, let end): return .between(start: start, end: end)
        }
    }

}
