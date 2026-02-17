//
//  DefaultFetchMovieCreditsUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

final class DefaultFetchMovieCreditsUseCase: FetchMovieCreditsUseCase {

    private let movieCreditsRepository: any MovieCreditsRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        movieCreditsRepository: some MovieCreditsRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.movieCreditsRepository = movieCreditsRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func execute(movieID: Movie.ID) async throws(FetchMovieCreditsError) -> CreditsDetails {
        let credits: Credits
        let appConfiguration: AppConfiguration
        do {
            (credits, appConfiguration) = try await (
                movieCreditsRepository.credits(forMovie: movieID),
                appConfigurationProvider.appConfiguration()
            )
        } catch let error {
            throw FetchMovieCreditsError(error)
        }

        let mapper = CreditsDetailsMapper()
        return mapper.map(credits, imagesConfiguration: appConfiguration.images)
    }

}
