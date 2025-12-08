//
//  SearchApplicationFactory.swift
//  SearchKit
//
//  Created by Adam Young on 15/10/2025.
//

import Foundation
import SearchDomain

public final class SearchApplicationFactory {

    private let mediaRepository: any MediaRepository
    private let appConfigurationProvider: any AppConfigurationProviding
    private let mediaProvider: any MediaProviding

    init(
        mediaRepository: some MediaRepository,
        appConfigurationProvider: some AppConfigurationProviding,
        mediaProvider: any MediaProviding
    ) {
        self.mediaRepository = mediaRepository
        self.appConfigurationProvider = appConfigurationProvider
        self.mediaProvider = mediaProvider
    }

    public func makeSearchMediaUseCase() -> some SearchMediaUseCase {
        DefaultSearchMediaUseCase(
            repository: mediaRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeFetchMediaSearchHistory() -> some FetchMediaSearchHistoryUseCase {
        DefaultFetchMediaSearchHistoryUseCase(
            repository: mediaRepository,
            appConfigurationProvider: appConfigurationProvider,
            mediaProvider: mediaProvider
        )
    }

    public func makeAddMediaSearchHistoryEntryUseCase() -> some AddMediaSearchHistoryEntryUseCase {
        DefaultAddMediaSearchHistoryEntryUseCase(repository: mediaRepository)
    }

}
