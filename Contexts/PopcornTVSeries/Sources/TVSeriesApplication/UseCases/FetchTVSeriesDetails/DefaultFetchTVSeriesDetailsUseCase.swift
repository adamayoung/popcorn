//
//  DefaultFetchTVSeriesDetailsUseCase.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import Observability
import TVSeriesDomain

final class DefaultFetchTVSeriesDetailsUseCase: FetchTVSeriesDetailsUseCase {

    private let repository: any TVSeriesRepository
    private let appConfigurationProvider: any AppConfigurationProviding
    private let themeColorProvider: (any ThemeColorProviding)?

    init(
        repository: some TVSeriesRepository,
        appConfigurationProvider: some AppConfigurationProviding,
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) {
        self.repository = repository
        self.appConfigurationProvider = appConfigurationProvider
        self.themeColorProvider = themeColorProvider
    }

    func execute(id: TVSeries.ID) async throws(FetchTVSeriesDetailsError) -> TVSeriesDetails {
        let span = SpanContext.startChild(
            operation: .useCaseExecute,
            description: "FetchTVSeriesDetailsUseCase.execute"
        )
        span?.setData(key: "tv_series_id", value: id)

        let tvSeriesDetails: TVSeriesDetails
        do {
            // All three fetches start immediately; theme-colour extraction then overlaps
            // the image-collection await rather than running serially after the fan-out.
            async let tvSeriesTask = repository.tvSeries(withID: id)
            async let imageCollectionTask = repository.images(forTVSeries: id)
            async let appConfigurationTask = appConfigurationProvider.appConfiguration()

            let tvSeries = try await tvSeriesTask
            let appConfiguration = try await appConfigurationTask

            async let themeColorTask = extractThemeColor(
                posterPath: tvSeries.posterPath,
                imagesConfiguration: appConfiguration.images
            )

            let imageCollection = try await imageCollectionTask
            let themeColor = await themeColorTask

            let mapper = TVSeriesDetailsMapper()
            tvSeriesDetails = mapper.map(
                tvSeries,
                imageCollection: imageCollection,
                imagesConfiguration: appConfiguration.images,
                themeColor: themeColor
            )
        } catch let error {
            let detailsError = FetchTVSeriesDetailsError(error)
            span?.setData(error: detailsError)
            span?.finish(status: .internalError)
            throw detailsError
        }

        span?.finish()
        return tvSeriesDetails
    }

}

extension DefaultFetchTVSeriesDetailsUseCase {

    private func extractThemeColor(
        posterPath: URL?,
        imagesConfiguration: ImagesConfiguration
    ) async -> ThemeColor? {
        guard
            let themeColorProvider,
            let thumbnailURL = imagesConfiguration.posterURLSet(for: posterPath)?.thumbnail
        else {
            return nil
        }

        return await themeColorProvider.themeColor(for: thumbnailURL)
    }

}
