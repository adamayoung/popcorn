//
//  GenresApplicationFactory+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import Foundation
import GenresComposition
import PopcornGenresAdapters

extension DependencyValues {

    var genresFactory: PopcornGenresFactory {
        PopcornGenresAdaptersFactory(
            genreService: self.genreService
        ).makeGenresFactory()
    }

}
