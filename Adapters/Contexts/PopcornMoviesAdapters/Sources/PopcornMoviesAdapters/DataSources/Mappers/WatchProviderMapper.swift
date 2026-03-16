//
//  WatchProviderMapper.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
import TMDb

struct WatchProviderMapper {

    func map(_ dto: TMDb.WatchProvider) -> MoviesDomain.WatchProvider {
        MoviesDomain.WatchProvider(
            id: dto.id,
            name: dto.name,
            logoPath: dto.logoPath
        )
    }

}
