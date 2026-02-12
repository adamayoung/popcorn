//
//  DefaultFetchTrendingPeopleUseCase.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import TrendingDomain

final class DefaultFetchTrendingPeopleUseCase: FetchTrendingPeopleUseCase {

    private let repository: any TrendingRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        repository: some TrendingRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.repository = repository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func execute() async throws(FetchTrendingPeopleError) -> [PersonPreviewDetails] {
        try await execute(page: 1)
    }

    func execute(page: Int) async throws(FetchTrendingPeopleError) -> [PersonPreviewDetails] {
        let personPreviews: [PersonPreview]
        let appConfiguration: AppConfiguration
        do {
            (personPreviews, appConfiguration) = try await (
                repository.people(page: page),
                appConfigurationProvider.appConfiguration()
            )
        } catch let error {
            throw FetchTrendingPeopleError(error)
        }

        let mapper = PersonPreviewDetailsMapper()
        return personPreviews.map {
            mapper.map($0, imagesConfiguration: appConfiguration.images)
        }
    }

}
