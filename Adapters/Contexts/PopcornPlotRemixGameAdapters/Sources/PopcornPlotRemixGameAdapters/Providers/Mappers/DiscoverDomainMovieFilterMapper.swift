//
//  DiscoverDomainMovieFilterMapper.swift
//  PopcornPlotRemixGameAdapters
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation
import PlotRemixGameDomain

///
/// A mapper that converts Plot Remix Game movie filters to Discover domain filters.
///
struct DiscoverDomainMovieFilterMapper {

    ///
    /// Maps a Plot Remix Game movie filter to a Discover domain movie filter.
    ///
    /// - Parameter filter: The Plot Remix Game movie filter to map.
    ///
    /// - Returns: A ``DiscoverDomain.MovieFilter`` with equivalent filter criteria.
    ///
    func map(_ filter: PlotRemixGameDomain.MovieFilter) -> DiscoverDomain.MovieFilter {
        DiscoverDomain.MovieFilter(
            originalLanguage: filter.originalLanguage,
            genres: filter.genres,
            primaryReleaseYear: map(filter.primaryReleaseYear)
        )
    }

    private func map(
        _ filter: PlotRemixGameDomain.PrimaryReleaseYearFilter?
    ) -> DiscoverDomain.MovieFilter.PrimaryReleaseYearFilter? {
        guard let filter else {
            return nil
        }

        switch filter {
        case .onYear(let year): return .onYear(year)
        case .fromYear(let year): return .fromYear(year)
        case .upToYear(let year): return .upToYear(year)
        case .betweenYears(let start, let end): return .betweenYears(start: start, end: end)
        }
    }

}
