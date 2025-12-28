//
//  PopcornSearchFactory.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SearchApplication
import SearchDomain
import SearchInfrastructure

///
/// A factory for creating search-related use cases.
///
/// This factory serves as the main entry point for the PopcornSearch module,
/// providing access to all search functionality through properly configured use cases.
/// It handles the composition of dependencies across the domain, application, and
/// infrastructure layers.
///
public struct PopcornSearchFactory {

    private let applicationFactory: SearchApplicationFactory

    ///
    /// Creates a new search factory instance.
    ///
    /// - Parameters:
    ///   - mediaRemoteDataSource: The data source for remote media searches.
    ///   - appConfigurationProvider: The provider for application configuration.
    ///   - mediaProvider: The provider for fetching individual media items.
    ///
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

    ///
    /// Creates a use case for searching media content.
    ///
    /// - Returns: A configured ``SearchMediaUseCase`` instance.
    ///
    public func makeSearchMediaUseCase() -> some SearchMediaUseCase {
        applicationFactory.makeSearchMediaUseCase()
    }

    ///
    /// Creates a use case for fetching the user's search history.
    ///
    /// - Returns: A configured ``FetchMediaSearchHistoryUseCase`` instance.
    ///
    public func makeFetchMediaSearchHistory() -> some FetchMediaSearchHistoryUseCase {
        applicationFactory.makeFetchMediaSearchHistory()
    }

    ///
    /// Creates a use case for adding items to the search history.
    ///
    /// - Returns: A configured ``AddMediaSearchHistoryEntryUseCase`` instance.
    ///
    public func makeAddMediaSearchHistoryEntryUseCase() -> some AddMediaSearchHistoryEntryUseCase {
        applicationFactory.makeAddMediaSearchHistoryEntryUseCase()
    }

}
