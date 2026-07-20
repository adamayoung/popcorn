//
//  DefaultFetchMovieRecommendationsUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

final class DefaultFetchMovieRecommendationsUseCase: FetchMovieRecommendationsUseCase {

    private let movieRecommendationRepository: any MovieRecommendationRepository
    private let movieImageRepository: any MovieImageRepository
    private let appConfigurationProvider: any AppConfigurationProviding
    private let themeColorProvider: (any ThemeColorProviding)?

    init(
        movieRecommendationRepository: some MovieRecommendationRepository,
        movieImageRepository: some MovieImageRepository,
        appConfigurationProvider: some AppConfigurationProviding,
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) {
        self.movieRecommendationRepository = movieRecommendationRepository
        self.movieImageRepository = movieImageRepository
        self.appConfigurationProvider = appConfigurationProvider
        self.themeColorProvider = themeColorProvider
    }

    func execute(movieID: Movie.ID) async throws(FetchMovieRecommendationsError) -> [MoviePreviewDetails] {
        try await execute(movieID: movieID, page: 1, limit: nil)
    }

    func execute(
        movieID: Movie.ID,
        page: Int
    ) async throws(FetchMovieRecommendationsError) -> [MoviePreviewDetails] {
        try await execute(movieID: movieID, page: page, limit: nil)
    }

    func execute(
        movieID: Movie.ID,
        page: Int,
        limit: Int?
    ) async throws(FetchMovieRecommendationsError) -> [MoviePreviewDetails] {
        let moviePreviews: [MoviePreview]
        let appConfiguration: AppConfiguration
        do {
            async let moviePreviewsTask = movieRecommendationRepository.recommendations(
                forMovie: movieID, page: page
            )
            async let appConfigurationTask = appConfigurationProvider.appConfiguration()
            (moviePreviews, appConfiguration) = try await (moviePreviewsTask, appConfigurationTask)
        } catch let error {
            throw FetchMovieRecommendationsError(error)
        }

        // Trim before enrichment so discarded movies never incur image/theme-colour work.
        let limitedPreviews = limit.map { Array(moviePreviews.prefix($0)) } ?? moviePreviews

        let imageCollections = await imageCollections(for: limitedPreviews)
        let themeColors = await extractThemeColors(
            for: limitedPreviews,
            imagesConfiguration: appConfiguration.images
        )

        let mapper = MoviePreviewDetailsMapper()
        return limitedPreviews.map {
            mapper.map(
                $0,
                imageCollection: imageCollections[$0.id],
                imagesConfiguration: appConfiguration.images,
                themeColor: themeColors[$0.id]
            )
        }
    }

}

extension DefaultFetchMovieRecommendationsUseCase {

    /// Fetches each movie's image collection concurrently. A per-movie failure is
    /// tolerated — that movie is simply absent from the result (its logo becomes nil)
    /// rather than failing the whole request.
    private func imageCollections(
        for moviePreviews: [MoviePreview]
    ) async -> [Int: ImageCollection] {
        await withTaskGroup(of: (Int, ImageCollection?).self) { taskGroup in
            for moviePreview in moviePreviews {
                taskGroup.addTask {
                    let imageCollection = try? await self.movieImageRepository.imageCollection(
                        forMovie: moviePreview.id
                    )
                    return (moviePreview.id, imageCollection)
                }
            }

            var results: [Int: ImageCollection] = [:]
            for await (id, imageCollection) in taskGroup {
                results[id] = imageCollection
            }

            return results
        }
    }

    /// Extracts each movie's theme colour concurrently from its poster thumbnail.
    private func extractThemeColors(
        for moviePreviews: [MoviePreview],
        imagesConfiguration: ImagesConfiguration
    ) async -> [Int: ThemeColor] {
        guard let themeColorProvider else {
            return [:]
        }

        return await withTaskGroup(of: (Int, ThemeColor?).self) { taskGroup in
            for moviePreview in moviePreviews {
                guard
                    let thumbnailURL = imagesConfiguration.posterURLSet(for: moviePreview.posterPath)?.thumbnail
                else {
                    continue
                }

                taskGroup.addTask {
                    let themeColor = await themeColorProvider.themeColor(for: thumbnailURL)
                    return (moviePreview.id, themeColor)
                }
            }

            var results: [Int: ThemeColor] = [:]
            for await (id, themeColor) in taskGroup {
                if let themeColor {
                    results[id] = themeColor
                }
            }

            return results
        }
    }

}
