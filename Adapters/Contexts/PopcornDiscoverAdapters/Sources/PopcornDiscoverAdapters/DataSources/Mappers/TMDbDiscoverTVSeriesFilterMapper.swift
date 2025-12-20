//
//  TMDbDiscoverTVSeriesFilterMapper.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation
import TMDb

struct TMDbDiscoverTVSeriesFilterMapper {

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
