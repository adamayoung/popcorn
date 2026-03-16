//
//  FetchMovieWatchProvidersUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

public protocol FetchMovieWatchProvidersUseCase: Sendable {

    func execute(movieID: Movie.ID) async throws(FetchMovieWatchProvidersError) -> WatchProviderCollectionDetails?

}
