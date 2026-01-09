//
//  SearchApplicationFactory+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import PopcornSearchAdapters
import SearchComposition

enum PopcornSearchFactoryKey: DependencyKey {

    static var liveValue: PopcornSearchFactory {
        @Dependency(\.searchService) var searchService
        @Dependency(\.fetchAppConfiguration) var fetchAppConfiguration
        @Dependency(\.fetchMovieDetails) var fetchMovieDetails
        @Dependency(\.fetchTVSeriesDetails) var fetchTVSeriesDetails
        @Dependency(\.fetchPersonDetails) var fetchPersonDetails
        return PopcornSearchAdaptersFactory(
            searchService: searchService,
            fetchAppConfigurationUseCase: fetchAppConfiguration,
            fetchMovieDetailsUseCase: fetchMovieDetails,
            fetchTVSeriesDetailsUseCase: fetchTVSeriesDetails,
            fetchPersonDetailsUseCase: fetchPersonDetails
        ).makeSearchFactory()
    }

}

extension DependencyValues {

    var searchFactory: PopcornSearchFactory {
        get { self[PopcornSearchFactoryKey.self] }
        set { self[PopcornSearchFactoryKey.self] = newValue }
    }

}
