//
//  DefaultSearchMediaUseCase.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import SearchDomain

final class DefaultSearchMediaUseCase: SearchMediaUseCase {

    private let repository: any MediaRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        repository: some MediaRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.repository = repository
        self.appConfigurationProvider = appConfigurationProvider
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

        let mapper = MediaPreviewDetailsMapper()
        let mediaPreviewDetails = mediaPreviews.map {
            mapper.map($0, imagesConfiguration: appConfiguration.images)
        }

        return mediaPreviewDetails
    }

}
