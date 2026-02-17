//
//  SpokenLanguageMapper.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
import TMDb

struct SpokenLanguageMapper {

    func map(_ dto: TMDb.SpokenLanguage) -> MoviesDomain.SpokenLanguage {
        MoviesDomain.SpokenLanguage(
            languageCode: dto.languageCode,
            name: dto.name
        )
    }

}
