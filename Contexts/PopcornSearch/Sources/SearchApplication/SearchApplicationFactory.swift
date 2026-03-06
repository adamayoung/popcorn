//
//  SearchApplicationFactory.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import SearchDomain

package final class SearchApplicationFactory: Sendable {

    private let mediaRepository: any MediaRepository
    private let appConfigurationProvider: any AppConfigurationProviding
    private let mediaProvider: any MediaProviding
    private let themeColorProvider: (any ThemeColorProviding)?

    package init(
        mediaRepository: some MediaRepository,
        appConfigurationProvider: some AppConfigurationProviding,
        mediaProvider: any MediaProviding,
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) {
        self.mediaRepository = mediaRepository
        self.appConfigurationProvider = appConfigurationProvider
        self.mediaProvider = mediaProvider
        self.themeColorProvider = themeColorProvider
    }

    package func makeSearchMediaUseCase() -> some SearchMediaUseCase {
        DefaultSearchMediaUseCase(
            repository: mediaRepository,
            appConfigurationProvider: appConfigurationProvider,
            themeColorProvider: themeColorProvider
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
