//
//  LivePopcornSearchFactory.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SearchApplication
import SearchDomain
import SearchInfrastructure

public final class LivePopcornSearchFactory: PopcornSearchFactory {

    private let applicationFactory: SearchApplicationFactory

    public init(
        mediaRemoteDataSource: some MediaRemoteDataSource,
        appConfigurationProvider: some AppConfigurationProviding,
        mediaProvider: some MediaProviding
    ) {
        let infrastructureFactory = SearchInfrastructureFactory(
            mediaRemoteDataSource: mediaRemoteDataSource
        )
        self.applicationFactory = SearchApplicationFactory(
            mediaRepository: infrastructureFactory.makeMediaRepository(),
            appConfigurationProvider: appConfigurationProvider,
            mediaProvider: mediaProvider
        )
    }

    public func makeSearchMediaUseCase() -> SearchMediaUseCase {
        applicationFactory.makeSearchMediaUseCase()
    }

    public func makeFetchMediaSearchHistory() -> FetchMediaSearchHistoryUseCase {
        applicationFactory.makeFetchMediaSearchHistory()
    }

    public func makeAddMediaSearchHistoryEntryUseCase() -> AddMediaSearchHistoryEntryUseCase {
        applicationFactory.makeAddMediaSearchHistoryEntryUseCase()
    }

}
