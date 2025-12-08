//
//  SearchApplicationFactory+TCA.swift
//  PopcornSearchAdapters
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import Foundation
import PopcornConfigurationAdapters
import PopcornMoviesAdapters
import PopcornPeopleAdapters
import PopcornTVAdapters
import SearchApplication
import TMDbAdapters

extension DependencyValues {

    var searchFactory: SearchApplicationFactory {
        PopcornSearchAdaptersFactory(
            searchService: self.searchService,
            fetchAppConfigurationUseCase: self.fetchAppConfiguration,
            fetchMovieDetailsUseCase: self.fetchMovieDetails,
            fetchTVSeriesDetailsUseCase: self.fetchTVSeriesDetails,
            fetchPersonDetailsUseCase: self.fetchPersonDetails
        ).makeSearchFactory()
    }

}
