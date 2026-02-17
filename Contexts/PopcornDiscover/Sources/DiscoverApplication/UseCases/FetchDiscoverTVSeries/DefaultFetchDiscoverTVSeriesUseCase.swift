//
//  DefaultFetchDiscoverTVSeriesUseCase.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import DiscoverDomain
import Foundation

final class DefaultFetchDiscoverTVSeriesUseCase: FetchDiscoverTVSeriesUseCase {

    private let repository: any DiscoverTVSeriesRepository
    private let genreProvider: any GenreProviding
    private let appConfigurationProvider: any AppConfigurationProviding
    private let logoImageProvider: any TVSeriesLogoImageProviding

    init(
        repository: some DiscoverTVSeriesRepository,
        genreProvider: some GenreProviding,
        appConfigurationProvider: some AppConfigurationProviding,
        logoImageProvider: some TVSeriesLogoImageProviding
    ) {
        self.repository = repository
        self.genreProvider = genreProvider
        self.appConfigurationProvider = appConfigurationProvider
        self.logoImageProvider = logoImageProvider
    }

    func execute() async throws(FetchDiscoverTVSeriesError) -> [TVSeriesPreviewDetails] {
        try await execute(filter: nil, page: 1)
    }

    func execute(filter: TVSeriesFilter) async throws(FetchDiscoverTVSeriesError)
    -> [TVSeriesPreviewDetails] {
        try await execute(filter: filter, page: 1)
    }

    func execute(page: Int) async throws(FetchDiscoverTVSeriesError) -> [TVSeriesPreviewDetails] {
        try await execute(filter: nil, page: page)
    }

    func execute(
        filter: TVSeriesFilter?,
        page: Int
    ) async throws(FetchDiscoverTVSeriesError) -> [TVSeriesPreviewDetails] {
        let moviePreviews: [TVSeriesPreview]
        let genres: [Genre]
        let appConfiguration: AppConfiguration
        do {
            (moviePreviews, genres, appConfiguration) = try await (
                repository.tvSeries(filter: filter, page: page),
                genreProvider.tvSeriesGenres(),
                appConfigurationProvider.appConfiguration()
            )
        } catch let error {
            throw FetchDiscoverTVSeriesError(error)
        }

        var genresLookup: [Genre.ID: Genre] = [:]
        for genre in genres {
            genresLookup[genre.id] = genre
        }

        let logoURLSets = try await logos(for: moviePreviews)

        let mapper = TVSeriesPreviewDetailsMapper()
        return moviePreviews.map {
            mapper.map(
                $0,
                genresLookup: genresLookup,
                logoURLSet: logoURLSets[$0.id],
                imagesConfiguration: appConfiguration.images
            )
        }
    }

}

extension DefaultFetchDiscoverTVSeriesUseCase {

    private func logos(
        for tvSeriesPreviews: [TVSeriesPreview]
    ) async throws(FetchDiscoverTVSeriesError) -> [Int: ImageURLSet] {
        let urlSets: [Int: ImageURLSet]
        do {
            urlSets = try await withThrowingTaskGroup { taskGroup in
                for tvSeriesPreview in tvSeriesPreviews {
                    taskGroup.addTask {
                        try await (
                            tvSeriesPreview.id,
                            self.logoImageProvider.imageURLSet(forTVSeries: tvSeriesPreview.id)
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
            throw FetchDiscoverTVSeriesError(error)
        }

        return urlSets
    }

}
