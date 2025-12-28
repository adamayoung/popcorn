//
//  TMDbDiscoverMovieFilterMapper.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation
import TMDb

///
/// Maps domain ``MovieFilter`` entities to TMDb ``DiscoverMovieFilter`` objects.
///
/// This mapper transforms the domain's movie filter criteria into the format
/// required by the TMDb discover API, enabling filtered movie discovery.
///
struct TMDbDiscoverMovieFilterMapper {

    ///
    /// Maps a domain movie filter to a TMDb discover movie filter.
    ///
    /// - Parameter dto: The domain movie filter to map, or nil for no filter.
    ///
    /// - Returns: A TMDb ``DiscoverMovieFilter`` if the input is non-nil, otherwise nil.
    ///
    func compactMap(_ dto: MovieFilter?) -> TMDb.DiscoverMovieFilter? {
        guard let dto else {
            return nil
        }

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
        guard let dto else {
            return nil
        }

        switch dto {
        case .onYear(let year): return .on(year)
        case .fromYear(let year): return .from(year)
        case .upToYear(let year): return .upTo(year)
        case .betweenYears(let start, let end): return .between(start: start, end: end)
        }
    }

}
