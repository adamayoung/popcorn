//
//  GenresApplicationFactory+TCA.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import GenresComposition
import PopcornGenresAdapters

extension DependencyValues {

    var genresFactory: PopcornGenresFactory {
        PopcornGenresAdaptersFactory(
            genreService: genreService
        ).makeGenresFactory()
    }

}
