//
//  SearchApplicationFactory+TCA.swift
//  SearchKitAdapters
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import ConfigurationKitAdapters
import Foundation
import MoviesKitAdapters
import PeopleKitAdapters
import SearchApplication
import TMDbAdapters
import TVKitAdapters

extension DependencyValues {

    var searchFactory: SearchApplicationFactory {
        SearchKitAdaptersFactory(
            searchService: self.searchService,
            fetchAppConfigurationUseCase: self.fetchAppConfiguration,
            fetchMovieDetailsUseCase: self.fetchMovieDetails,
            fetchTVSeriesDetailsUseCase: self.fetchTVSeriesDetails,
            fetchPersonDetailsUseCase: self.fetchPersonDetails
        ).makeSearchFactory()
    }

}
