//
//  DefaultFetchDiscoverMoviesUseCase.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import DiscoverDomain
import Foundation
import Observability

final class DefaultFetchDiscoverMoviesUseCase: FetchDiscoverMoviesUseCase {

    private let repository: any DiscoverMovieRepository
    private let genreProvider: any GenreProviding
    private let appConfigurationProvider: any AppConfigurationProviding
    private let logoImageProvider: any MovieLogoImageProviding
    private let themeColorProvider: (any ThemeColorProviding)?

    init(
        repository: some DiscoverMovieRepository,
        genreProvider: some GenreProviding,
        appConfigurationProvider: some AppConfigurationProviding,
        logoImageProvider: some MovieLogoImageProviding,
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) {
        self.repository = repository
        self.genreProvider = genreProvider
        self.appConfigurationProvider = appConfigurationProvider
        self.logoImageProvider = logoImageProvider
        self.themeColorProvider = themeColorProvider
    }

    func execute() async throws(FetchDiscoverMoviesError) -> [MoviePreviewDetails] {
        try await execute(filter: nil, page: 1)
    }

    func execute(
        filter: MovieFilter
    ) async throws(FetchDiscoverMoviesError) -> [MoviePreviewDetails] {
        try await execute(filter: filter, page: 1)
    }

    func execute(page: Int) async throws(FetchDiscoverMoviesError) -> [MoviePreviewDetails] {
        try await execute(filter: nil, page: page)
    }

    func execute(
        filter: MovieFilter?,
        page: Int
    ) async throws(FetchDiscoverMoviesError) -> [MoviePreviewDetails] {
        let span = SpanContext.startChild(
            operation: .useCaseExecute,
            description: "FetchDiscoverMoviesUseCase.execute"
        )
        span?.setData([
            "filter": filter?.dictionary ?? "nil",
            "page": page
        ])

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
            let moviesError = FetchDiscoverMoviesError(error)
            span?.setData(error: moviesError)
            span?.finish(status: .internalError)
            throw moviesError
        }

        let moviePreviewDetails = try await mapMoviePreviews(
            moviePreviews,
            genres: genres,
            appConfiguration: appConfiguration,
            span: span
        )

        span?.finish()
        return moviePreviewDetails
    }

    private func mapMoviePreviews(
        _ moviePreviews: [MoviePreview],
        genres: [Genre],
        appConfiguration: AppConfiguration,
        span: (any Span)?
    ) async throws(FetchDiscoverMoviesError) -> [MoviePreviewDetails] {
        var genresLookup: [Genre.ID: Genre] = [:]
        for genre in genres {
            genresLookup[genre.id] = genre
        }

        let logoURLSets: [Int: ImageURLSet]
        do {
            logoURLSets = try await logos(for: moviePreviews)
        } catch let error {
            span?.setData(error: error)
            span?.finish(status: .internalError)
            throw error
        }

        let themeColors = await extractThemeColors(
            for: moviePreviews,
            imagesConfiguration: appConfiguration.images
        )

        let mapper = MoviePreviewDetailsMapper()
        return moviePreviews.map {
            mapper.map(
                $0,
                genresLookup: genresLookup,
                logoURLSet: logoURLSets[$0.id],
                imagesConfiguration: appConfiguration.images,
                themeColor: themeColors[$0.id]
            )
        }
    }

}

extension DefaultFetchDiscoverMoviesUseCase {

    private func extractThemeColors(
        for moviePreviews: [MoviePreview],
        imagesConfiguration: ImagesConfiguration
    ) async -> [Int: ThemeColor] {
        guard let themeColorProvider else {
            return [:]
        }

        var results: [Int: ThemeColor] = [:]

        for moviePreview in moviePreviews {
            guard let thumbnailURL = imagesConfiguration.posterURLSet(for: moviePreview.posterPath)?.thumbnail
            else {
                continue
            }
            if let themeColor = await themeColorProvider.themeColor(for: thumbnailURL) {
                results[moviePreview.id] = themeColor
            }
        }

        return results
    }

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
