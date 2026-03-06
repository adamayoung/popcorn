//
//  GenresApplicationFactory+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import GenresComposition
import PopcornGenresAdapters

enum PopcornGenresFactoryKey: DependencyKey {

    static var liveValue: PopcornGenresFactory {
        @Dependency(\.genreService) var genreService
        @Dependency(\.discoverService) var discoverService
        @Dependency(\.fetchAppConfiguration) var fetchAppConfiguration
        return PopcornGenresAdaptersFactory(
            genreService: genreService,
            discoverService: discoverService,
            fetchAppConfigurationUseCase: fetchAppConfiguration
        ).makeGenresFactory()
    }

}

extension DependencyValues {

    var genresFactory: PopcornGenresFactory {
        get { self[PopcornGenresFactoryKey.self] }
        set { self[PopcornGenresFactoryKey.self] = newValue }
    }

}
