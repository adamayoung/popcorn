//
//  TMDbDiscoverTVSeriesFilterMapper.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation
import TMDb

///
/// Maps domain ``TVSeriesFilter`` entities to TMDb ``DiscoverTVSeriesFilter`` objects.
///
/// This mapper transforms the domain's TV series filter criteria into the format
/// required by the TMDb discover API, enabling filtered TV series discovery.
///
struct TMDbDiscoverTVSeriesFilterMapper {

    ///
    /// Maps a domain TV series filter to a TMDb discover TV series filter.
    ///
    /// - Parameter dto: The domain TV series filter to map, or nil for no filter.
    ///
    /// - Returns: A TMDb ``DiscoverTVSeriesFilter`` if the input is non-nil, otherwise nil.
    ///
    func compactMap(_ dto: TVSeriesFilter?) -> TMDb.DiscoverTVSeriesFilter? {
        guard let dto else {
            return nil
        }

        return DiscoverTVSeriesFilter(
            originalLanguage: dto.originalLanguage,
            genres: dto.genres
        )
    }

}
