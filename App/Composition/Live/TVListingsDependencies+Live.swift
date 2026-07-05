//
//  TVListingsDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import Foundation
import TVListingsApplication
import TVListingsComposition
import TVListingsFeature

extension TVListingsDependencies {

    /// UserDefaults key for the persisted selected-region id.
    private static let selectedRegionDefaultsKey = "popcorn.tvlistings.selectedRegionID"

    /// Builds the production dependencies from the app's shared services.
    /// Syncing is handled app-level (see `AppRootViewModel`); this feature only reads.
    static func live(services: AppServices) -> TVListingsDependencies {
        let fetchChannels = services.tvListingsFactory.makeFetchChannelsUseCase()
        let fetchTVRegions = services.tvListingsFactory.makeFetchTVRegionsUseCase()
        let fetchTVListings = services.tvListingsFactory.makeFetchTVListingsUseCase()

        return TVListingsDependencies(
            fetchChannels: {
                try await fetchChannels.execute()
            },
            fetchRegions: {
                try await fetchTVRegions.execute()
            },
            fetchListings: {
                try await fetchTVListings.execute()
            },
            // `UserDefaults.standard` is a thread-safe shared instance; referencing it directly
            // keeps these `@Sendable` closures clean (no captured non-Sendable state).
            loadSelectedRegionID: {
                UserDefaults.standard.string(forKey: Self.selectedRegionDefaultsKey)
            },
            saveSelectedRegionID: { id in
                UserDefaults.standard.set(id, forKey: Self.selectedRegionDefaultsKey)
            }
        )
    }

}
