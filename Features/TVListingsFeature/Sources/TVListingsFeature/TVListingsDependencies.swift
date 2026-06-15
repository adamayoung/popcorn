//
//  TVListingsDependencies.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import Foundation
import TVListingsDomain

/// The dependencies required by ``TVListingsViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``TVListingsViewModel``. Constructing it requires every closure, so a
/// missing dependency is a compile error. Build the production instance with
/// ``live(services:)``.
public struct TVListingsDependencies: Sendable {

    public var fetchChannels: @Sendable () async throws -> [Channel]
    public var fetchRegions: @Sendable () async throws -> [TVRegion]
    public var fetchListings: @Sendable () async throws -> [TVProgramme]
    /// The persisted selected-region id, or `nil` if the user hasn't chosen one.
    public var loadSelectedRegionID: @Sendable () -> String?
    /// Persists the selected-region id.
    public var saveSelectedRegionID: @Sendable (String) -> Void

    public init(
        fetchChannels: @escaping @Sendable () async throws -> [Channel],
        fetchRegions: @escaping @Sendable () async throws -> [TVRegion],
        fetchListings: @escaping @Sendable () async throws -> [TVProgramme],
        loadSelectedRegionID: @escaping @Sendable () -> String?,
        saveSelectedRegionID: @escaping @Sendable (String) -> Void
    ) {
        self.fetchChannels = fetchChannels
        self.fetchRegions = fetchRegions
        self.fetchListings = fetchListings
        self.loadSelectedRegionID = loadSelectedRegionID
        self.saveSelectedRegionID = saveSelectedRegionID
    }

}

public extension TVListingsDependencies {

    /// UserDefaults key for the persisted selected-region id.
    private static let selectedRegionDefaultsKey = "popcorn.tvlistings.selectedRegionID"

    /// Builds the production dependencies from the app's shared services.
    /// Syncing is handled app-level (see `AppRootViewModel`); this feature only reads.
    static func live(services: AppServices) -> TVListingsDependencies {
        let fetchChannels = services.tvListingsFactory.makeFetchChannelsUseCase()
        let fetchTVRegions = services.tvListingsFactory.makeFetchTVRegionsUseCase()
        let fetchTVListings = services.tvListingsFactory.makeFetchTVListingsUseCase()
        nonisolated(unsafe) let defaults = UserDefaults.standard
        let key = selectedRegionDefaultsKey

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
            loadSelectedRegionID: {
                defaults.string(forKey: key)
            },
            saveSelectedRegionID: { id in
                defaults.set(id, forKey: key)
            }
        )
    }

}

#if DEBUG
    public extension TVListingsDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: TVListingsDependencies {
            TVListingsDependencies(
                fetchChannels: { [] },
                fetchRegions: { [] },
                fetchListings: { [] },
                loadSelectedRegionID: { nil },
                saveSelectedRegionID: { _ in }
            )
        }

    }
#endif
