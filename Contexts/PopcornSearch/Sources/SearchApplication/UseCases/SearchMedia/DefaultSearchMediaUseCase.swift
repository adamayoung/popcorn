//
//  DefaultSearchMediaUseCase.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import SearchDomain

final class DefaultSearchMediaUseCase: SearchMediaUseCase {

    private let repository: any MediaRepository
    private let appConfigurationProvider: any AppConfigurationProviding
    private let themeColorProvider: (any ThemeColorProviding)?

    init(
        repository: some MediaRepository,
        appConfigurationProvider: some AppConfigurationProviding,
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) {
        self.repository = repository
        self.appConfigurationProvider = appConfigurationProvider
        self.themeColorProvider = themeColorProvider
    }

    func execute(query: String) async throws(SearchMediaError) -> [MediaPreviewDetails] {
        try await execute(query: query, page: 1)
    }

    func execute(query: String, page: Int) async throws(SearchMediaError) -> [MediaPreviewDetails] {
        let mediaPreviews: [MediaPreview]
        let appConfiguration: AppConfiguration
        do {
            (mediaPreviews, appConfiguration) = try await (
                repository.search(query: query, page: page),
                appConfigurationProvider.appConfiguration()
            )
        } catch let error {
            throw SearchMediaError(error)
        }

        let themeColors = await extractThemeColors(
            for: mediaPreviews,
            imagesConfiguration: appConfiguration.images
        )

        let mapper = MediaPreviewDetailsMapper()
        return mediaPreviews.map {
            mapper.map(
                $0,
                imagesConfiguration: appConfiguration.images,
                themeColor: themeColors[$0.id]
            )
        }
    }

}

extension DefaultSearchMediaUseCase {

    private func extractThemeColors(
        for mediaPreviews: [MediaPreview],
        imagesConfiguration: ImagesConfiguration
    ) async -> [Int: ThemeColor] {
        guard let themeColorProvider else {
            return [:]
        }

        var results: [Int: ThemeColor] = [:]

        for mediaPreview in mediaPreviews {
            let posterPath: URL? = switch mediaPreview {
            case .movie(let movie): movie.posterPath
            case .tvSeries(let tvSeries): tvSeries.posterPath
            case .person: nil
            }

            guard let posterPath,
                  let thumbnailURL = imagesConfiguration.posterURLSet(for: posterPath)?.thumbnail
            else {
                continue
            }

            if let themeColor = await themeColorProvider.themeColor(for: thumbnailURL) {
                results[mediaPreview.id] = themeColor
            }
        }

        return results
    }

}
