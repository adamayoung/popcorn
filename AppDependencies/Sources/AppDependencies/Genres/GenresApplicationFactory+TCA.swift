//
//  GenresApplicationFactory+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import GenresComposition
import PopcornGenresAdapters

enum PopcornGenresFactoryKey: DependencyKey {

    static var liveValue: PopcornGenresFactory {
        @Dependency(\.genreService) var genreService
        return PopcornGenresAdaptersFactory(
            genreService: genreService
        ).makeGenresFactory()
    }

}

extension DependencyValues {

    var genresFactory: PopcornGenresFactory {
        get { self[PopcornGenresFactoryKey.self] }
        set { self[PopcornGenresFactoryKey.self] = newValue }
    }

}
