//
//  TMDbDiscoverTVSeriesFilterMapper.swift
//  PopcornDiscoverAdapters
//
//  Created by Adam Young on 08/12/2025.
//

import DiscoverDomain
import Foundation
import TMDb

struct TMDbDiscoverTVSeriesFilterMapper {

    func compactMap(_ dto: TVSeriesFilter?) -> TMDb.DiscoverTVSeriesFilter? {
        guard let dto else { return nil }

        return DiscoverTVSeriesFilter(
            originalLanguage: dto.originalLanguage,
            genres: dto.genres
        )
    }

}
