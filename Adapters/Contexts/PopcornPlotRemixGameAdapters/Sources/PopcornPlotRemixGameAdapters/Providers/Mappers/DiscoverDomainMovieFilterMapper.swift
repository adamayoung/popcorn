//
//  DiscoverDomainMovieFilterMapper.swift
//  PopcornPlotRemixGameAdapters
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation
import PlotRemixGameDomain

struct DiscoverDomainMovieFilterMapper {

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
