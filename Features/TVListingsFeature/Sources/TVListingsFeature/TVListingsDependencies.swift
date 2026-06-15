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
    public var fetchListings: @Sendable () async throws -> [TVProgramme]

    public init(
        fetchChannels: @escaping @Sendable () async throws -> [Channel],
        fetchListings: @escaping @Sendable () async throws -> [TVProgramme]
    ) {
        self.fetchChannels = fetchChannels
        self.fetchListings = fetchListings
    }

}

public extension TVListingsDependencies {

    /// Builds the production dependencies from the app's shared services.
    /// Syncing is handled app-level (see `AppRootViewModel`); this feature only reads.
    static func live(services: AppServices) -> TVListingsDependencies {
        let fetchChannels = services.tvListingsFactory.makeFetchChannelsUseCase()
        let fetchTVListings = services.tvListingsFactory.makeFetchTVListingsUseCase()

        return TVListingsDependencies(
            fetchChannels: {
                try await fetchChannels.execute()
            },
            fetchListings: {
                try await fetchTVListings.execute()
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
                fetchListings: { [] }
            )
        }

    }
#endif
