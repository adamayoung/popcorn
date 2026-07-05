//
//  TVListingsDependencies.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

/// The dependencies required by ``TVListingsViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``TVListingsViewModel``. Constructing it requires every closure, so a
/// missing dependency is a compile error. The production instance is built by the app's
/// composition layer; use ``preview`` for previews and tests.
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
