//
//  DefaultFetchDiscoverMoviesUseCase.swift
//  PopcornDiscover
//
//  Created by Adam Young on 08/12/2025.
//

import CoreDomain
import DiscoverDomain
import Foundation

final class DefaultFetchDiscoverMoviesUseCase: FetchDiscoverMoviesUseCase {

    private let repository: any DiscoverMovieRepository
    private let genreProvider: any GenreProviding
    private let appConfigurationProvider: any AppConfigurationProviding
    private let logoImageProvider: any MovieLogoImageProviding

    init(
        repository: some DiscoverMovieRepository,
        genreProvider: some GenreProviding,
        appConfigurationProvider: some AppConfigurationProviding,
        logoImageProvider: some MovieLogoImageProviding
    ) {
        self.repository = repository
        self.genreProvider = genreProvider
        self.appConfigurationProvider = appConfigurationProvider
        self.logoImageProvider = logoImageProvider
    }

    func execute() async throws(FetchDiscoverMoviesError) -> [MoviePreviewDetails] {
        try await self.execute(filter: nil, page: 1)
    }

    func execute(filter: MovieFilter) async throws(FetchDiscoverMoviesError)
        -> [MoviePreviewDetails]
    {
        try await execute(filter: filter, page: 1)
    }

    func execute(page: Int) async throws(FetchDiscoverMoviesError) -> [MoviePreviewDetails] {
        try await execute(filter: nil, page: page)
    }

    func execute(
        filter: MovieFilter?,
        page: Int
    ) async throws(FetchDiscoverMoviesError) -> [MoviePreviewDetails] {
        let moviePreviews: [MoviePreview]
        let genres: [Genre]
        let appConfiguration: AppConfiguration
        do {
            (moviePreviews, genres, appConfiguration) = try await (
                repository.movies(filter: filter, page: page),
                genreProvider.movieGenres(),
                appConfigurationProvider.appConfiguration()
            )
        } catch let error {
            throw FetchDiscoverMoviesError(error)
        }

        var genresLookup: [Genre.ID: Genre] = [:]
        for genre in genres {
            genresLookup[genre.id] = genre
        }

        let logoURLSets = try await logos(for: moviePreviews)

        let mapper = MoviePreviewDetailsMapper()
        let moviePreviewDetails = moviePreviews.map {
            mapper.map(
                $0,
                genresLookup: genresLookup,
                logoURLSet: logoURLSets[$0.id],
                imagesConfiguration: appConfiguration.images
            )
        }

        return moviePreviewDetails
    }

}

extension DefaultFetchDiscoverMoviesUseCase {

    private func logos(
        for moviePreviews: [MoviePreview]
    ) async throws(FetchDiscoverMoviesError) -> [Int: ImageURLSet] {
        let urlSets: [Int: ImageURLSet]
        do {
            urlSets = try await withThrowingTaskGroup { taskGroup in
                for moviePreview in moviePreviews {
                    taskGroup.addTask {
                        try await (
                            moviePreview.id,
                            self.logoImageProvider.imageURLSet(forMovie: moviePreview.id)
                        )
                    }
                }

                var results: [Int: ImageURLSet] = [:]
                for try await (id, imageURLSet) in taskGroup {
                    results[id] = imageURLSet
                }

                return results
            }
        } catch let error {
            throw FetchDiscoverMoviesError(error)
        }

        return urlSets
    }

}
