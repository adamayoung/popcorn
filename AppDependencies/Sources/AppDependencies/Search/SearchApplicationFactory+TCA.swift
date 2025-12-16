//
//  SearchApplicationFactory+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import Foundation
import PopcornSearchAdapters
import SearchComposition

extension DependencyValues {

    var searchFactory: PopcornSearchFactory {
        PopcornSearchAdaptersFactory(
            searchService: self.searchService,
            fetchAppConfigurationUseCase: self.fetchAppConfiguration,
            fetchMovieDetailsUseCase: self.fetchMovieDetails,
            fetchTVSeriesDetailsUseCase: self.fetchTVSeriesDetails,
            fetchPersonDetailsUseCase: self.fetchPersonDetails
        ).makeSearchFactory()
    }

}
