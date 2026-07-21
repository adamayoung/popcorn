//
//  DefaultFetchTrendingMoviesUseCase.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TrendingDomain

final class DefaultFetchTrendingMoviesUseCase: FetchTrendingMoviesUseCase {

    private let repository: any TrendingRepository
    private let appConfigurationProvider: any AppConfigurationProviding
    private let logoImageProvider: any MovieLogoImageProviding
    private let themeColorProvider: (any ThemeColorProviding)?

    init(
        repository: some TrendingRepository,
        appConfigurationProvider: some AppConfigurationProviding,
        logoImageProvider: some MovieLogoImageProviding,
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) {
        self.repository = repository
        self.appConfigurationProvider = appConfigurationProvider
        self.logoImageProvider = logoImageProvider
        self.themeColorProvider = themeColorProvider
    }

    func execute() async throws(FetchTrendingMoviesError) -> MoviePreviewDetailsPage {
        try await execute(page: 1)
    }

    func execute(page: Int) async throws(FetchTrendingMoviesError) -> MoviePreviewDetailsPage {
        let moviePreviewPage: MoviePreviewPage
        let appConfiguration: AppConfiguration
        do {
            async let moviePreviewPageTask = repository.movies(page: page)
            async let appConfigurationTask = appConfigurationProvider.appConfiguration()
            (moviePreviewPage, appConfiguration) = try await (moviePreviewPageTask, appConfigurationTask)
        } catch let error {
            throw FetchTrendingMoviesError(error)
        }

        let themeColors = await extractThemeColors(
            for: moviePreviewPage.movies,
            imagesConfiguration: appConfiguration.images
        )

        let mapper = MoviePreviewDetailsMapper()
        let movies = moviePreviewPage.movies.map {
            mapper.map(
                $0,
                imagesConfiguration: appConfiguration.images,
                themeColor: themeColors[$0.id]
            )
        }

        return MoviePreviewDetailsPage(
            page: moviePreviewPage.page,
            totalPages: moviePreviewPage.totalPages,
            movies: movies
        )
    }

}

extension DefaultFetchTrendingMoviesUseCase {

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

}
