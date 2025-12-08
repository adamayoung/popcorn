//
//  DefaultFetchMediaSearchHistoryUseCase.swift
//  SearchKit
//
//  Created by Adam Young on 04/12/2025.
//

import CoreDomain
import Foundation
import SearchDomain

final class DefaultFetchMediaSearchHistoryUseCase: FetchMediaSearchHistoryUseCase {

    private let repository: any MediaRepository
    private let appConfigurationProvider: any AppConfigurationProviding
    private let mediaProvider: any MediaProviding

    init(
        repository: some MediaRepository,
        appConfigurationProvider: some AppConfigurationProviding,
        mediaProvider: some MediaProviding
    ) {
        self.repository = repository
        self.appConfigurationProvider = appConfigurationProvider
        self.mediaProvider = mediaProvider
    }

    func execute() async throws(FetchMediaSearchHistoryError) -> [MediaPreviewDetails] {
        let entries: [MediaSearchHistoryEntry]
        let appConfiguration: AppConfiguration
        do {
            (entries, appConfiguration) = try await (
                repository.mediaSearchHistory(),
                appConfigurationProvider.appConfiguration()
            )
        } catch let error {
            throw FetchMediaSearchHistoryError(error)
        }

        let mediaPreviews = try await mediaPreviews(from: entries)

        let mapper = MediaPreviewDetailsMapper()
        let mediaPreviewDetails = mediaPreviews.map {
            mapper.map($0, imagesConfiguration: appConfiguration.images)
        }

        return mediaPreviewDetails
    }

}

extension DefaultFetchMediaSearchHistoryUseCase {

    private func mediaPreviews(
        from entries: [MediaSearchHistoryEntry]
    ) async throws(FetchMediaSearchHistoryError) -> [MediaPreview] {
        do {
            return try await withThrowingTaskGroup { taskGroup in
                var results: [(Date, MediaPreview)] = []

                for entry in entries {
                    taskGroup.addTask {
                        switch entry {
                        case .movie:
                            let moviePreview = try await self.mediaProvider.movie(withID: entry.id)
                            return (entry.timestamp, MediaPreview.movie(moviePreview))

                        case .tvSeries:
                            let tvSeriesPreview = try await self.mediaProvider.tvSeries(
                                withID: entry.id)
                            return (entry.timestamp, MediaPreview.tvSeries(tvSeriesPreview))
                        case .person:
                            let personPreview = try await self.mediaProvider.person(
                                withID: entry.id)
                            return (entry.timestamp, MediaPreview.person(personPreview))
                        }
                    }
                }

                for try await result in taskGroup {
                    results.append(result)
                }

                results.sort { $0.0 > $1.0 }
                return results.map { $0.1 }
            }
        } catch let error {
            throw FetchMediaSearchHistoryError(error)
        }
    }

}
