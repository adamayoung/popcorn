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

extension DependencyValues {

    var searchFactory: PopcornSearchFactory {
        PopcornSearchAdaptersFactory(
            searchService: searchService,
            fetchAppConfigurationUseCase: fetchAppConfiguration,
            fetchMovieDetailsUseCase: fetchMovieDetails,
            fetchTVSeriesDetailsUseCase: fetchTVSeriesDetails,
            fetchPersonDetailsUseCase: fetchPersonDetails
        ).makeSearchFactory()
    }

}
