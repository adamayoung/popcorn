//
//  DefaultFetchMovieWatchProvidersUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

final class DefaultFetchMovieWatchProvidersUseCase: FetchMovieWatchProvidersUseCase {

    private let movieWatchProvidersRepository: any MovieWatchProvidersRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        movieWatchProvidersRepository: some MovieWatchProvidersRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.movieWatchProvidersRepository = movieWatchProvidersRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func execute(movieID: Movie.ID) async throws(FetchMovieWatchProvidersError) -> WatchProviderCollectionDetails? {
        let watchProviders: WatchProviderCollection?
        let appConfiguration: AppConfiguration
        do {
            (watchProviders, appConfiguration) = try await (
                movieWatchProvidersRepository.watchProviders(forMovie: movieID),
                appConfigurationProvider.appConfiguration()
            )
        } catch let error {
            throw FetchMovieWatchProvidersError(error)
        }

        guard let watchProviders else {
            return nil
        }

        let mapper = WatchProviderCollectionDetailsMapper()
        return mapper.map(watchProviders, imagesConfiguration: appConfiguration.images)
    }

}
