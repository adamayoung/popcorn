//
//  GenresApplicationFactory+TCA.swift
//  PopcornGenresAdapters
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import Foundation
import GenresApplication
import TMDbAdapters

extension DependencyValues {

    var genresFactory: GenresApplicationFactory {
        PopcornGenresAdaptersFactory(
            genreService: self.genreService
        ).makeGenresFactory()
    }

}
