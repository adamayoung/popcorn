//
//  DefaultStreamTVSeriesDetailsUseCase.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import OSLog
import TVSeriesDomain

final class DefaultStreamTVSeriesDetailsUseCase: StreamTVSeriesDetailsUseCase {

    private static let logger = Logger.tvSeriesApplication

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

    func stream(id: Int) async -> AsyncThrowingStream<TVSeriesDetails?, Error> {
        Self.logger.debug("Starting stream for TVSeriesDetails [tvSeriesID: \(id, privacy: .private)]")

        let stream = await repository.tvSeriesStream(withID: id)
        return AsyncThrowingStream { continuation in
            let task = Task {
                do {
                    var lastValue: TVSeriesDetails?

                    for try await tvSeries in stream {
                        guard let tvSeries else {
                            continuation.yield(nil)
                            continue
                        }

                        let tvSeriesDetails: TVSeriesDetails
                        do {
                            tvSeriesDetails = try await buildTVSeriesDetails(for: tvSeries, id: id)
                        } catch {
                            // Skip this tick but keep the stream alive for the next emission —
                            // a transient per-tick failure must not kill the whole stream.
                            Self.logger.error(
                                "Failed building TVSeriesDetails in stream [tvSeriesID: \(id, privacy: .private)]: \(error.localizedDescription, privacy: .public)"
                            )
                            continue
                        }

                        guard lastValue != tvSeriesDetails else {
                            continue
                        }

                        lastValue = tvSeriesDetails
                        continuation.yield(tvSeriesDetails)
                    }

                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }

            continuation.onTermination = { _ in
                task.cancel()
                Self.logger.debug(
                    "Cancelled stream for TVSeriesDetails [tvSeriesID: \(id, privacy: .private)]"
                )
            }
        }
    }

    private func buildTVSeriesDetails(
        for tvSeries: TVSeries,
        id: Int
    ) async throws -> TVSeriesDetails {
        let imageCollection: ImageCollection
        let appConfiguration: AppConfiguration
        do {
            async let imageCollectionTask = repository.images(forTVSeries: id)
            async let appConfigurationTask = appConfigurationProvider.appConfiguration()
            (imageCollection, appConfiguration) = try await (imageCollectionTask, appConfigurationTask)
        } catch let error {
            throw FetchTVSeriesDetailsError(error)
        }

        let themeColor = await extractThemeColor(
            posterPath: tvSeries.posterPath,
            imagesConfiguration: appConfiguration.images
        )

        let mapper = TVSeriesDetailsMapper()
        return mapper.map(
            tvSeries,
            imageCollection: imageCollection,
            imagesConfiguration: appConfiguration.images,
            themeColor: themeColor
        )
    }

}

extension DefaultStreamTVSeriesDetailsUseCase {

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
