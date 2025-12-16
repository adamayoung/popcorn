//
//  PopcornSearchFactory.swift
//  PopcornSearch
//
//  Created by Adam Young on 15/12/2025.
//

import Foundation
import SearchApplication
import SearchDomain
import SearchInfrastructure

public struct PopcornSearchFactory {

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

    public func makeSearchMediaUseCase() -> some SearchMediaUseCase {
        applicationFactory.makeSearchMediaUseCase()
    }

    public func makeFetchMediaSearchHistory() -> some FetchMediaSearchHistoryUseCase {
        applicationFactory.makeFetchMediaSearchHistory()
    }

    public func makeAddMediaSearchHistoryEntryUseCase() -> some AddMediaSearchHistoryEntryUseCase {
        applicationFactory.makeAddMediaSearchHistoryEntryUseCase()
    }

}
