//
//  SearchComposition.swift
//  SearchKit
//
//  Created by Adam Young on 20/11/2025.
//

import Foundation
import SearchDomain
import SearchInfrastructure

public struct SearchComposition {

    private init() {}

    public static func makeSearchFactory(
        mediaRemoteDataSource: some MediaRemoteDataSource,
        appConfigurationProvider: some AppConfigurationProviding,
        mediaProvider: some MediaProviding
    ) -> SearchApplicationFactory {
        let infrastructureFactory = SearchInfrastructureFactory(
            mediaRemoteDataSource: mediaRemoteDataSource
        )
        let mediaRepository = infrastructureFactory.makeMediaRepository()

        return SearchApplicationFactory(
            mediaRepository: mediaRepository,
            appConfigurationProvider: appConfigurationProvider,
            mediaProvider: mediaProvider
        )
    }

}
