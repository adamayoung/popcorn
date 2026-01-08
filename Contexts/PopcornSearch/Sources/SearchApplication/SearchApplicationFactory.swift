//
//  SearchApplicationFactory.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SearchDomain

package final class SearchApplicationFactory: Sendable {

    private let mediaRepository: any MediaRepository
    private let appConfigurationProvider: any AppConfigurationProviding
    private let mediaProvider: any MediaProviding

    package init(
        mediaRepository: some MediaRepository,
        appConfigurationProvider: some AppConfigurationProviding,
        mediaProvider: any MediaProviding
    ) {
        self.mediaRepository = mediaRepository
        self.appConfigurationProvider = appConfigurationProvider
        self.mediaProvider = mediaProvider
    }

    package func makeSearchMediaUseCase() -> some SearchMediaUseCase {
        DefaultSearchMediaUseCase(
            repository: mediaRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    package func makeFetchMediaSearchHistory() -> some FetchMediaSearchHistoryUseCase {
        DefaultFetchMediaSearchHistoryUseCase(
            repository: mediaRepository,
            appConfigurationProvider: appConfigurationProvider,
            mediaProvider: mediaProvider
        )
    }

    package func makeAddMediaSearchHistoryEntryUseCase() -> some AddMediaSearchHistoryEntryUseCase {
        DefaultAddMediaSearchHistoryEntryUseCase(repository: mediaRepository)
    }

}
