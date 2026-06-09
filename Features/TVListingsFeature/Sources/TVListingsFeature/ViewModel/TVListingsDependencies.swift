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
/// A plain `Sendable` struct of closures — the MVVM replacement for the former
/// `TVListingsClient` (`@DependencyClient`). Constructing it requires every
/// closure, so a missing dependency is a compile error. Build the production
/// instance with ``live(services:)``.
public struct TVListingsDependencies: Sendable {

    public var sync: @Sendable () async throws -> Void
    public var fetchChannels: @Sendable () async throws -> [TVChannel]
    public var fetchNowPlayingProgrammes: @Sendable () async throws -> [TVProgramme]

    public init(
        sync: @escaping @Sendable () async throws -> Void,
        fetchChannels: @escaping @Sendable () async throws -> [TVChannel],
        fetchNowPlayingProgrammes: @escaping @Sendable () async throws -> [TVProgramme]
    ) {
        self.sync = sync
        self.fetchChannels = fetchChannels
        self.fetchNowPlayingProgrammes = fetchNowPlayingProgrammes
    }

}

public extension TVListingsDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Mirrors the former `TVListingsClient.liveValue` exactly: same use cases.
    static func live(services: AppServices) -> TVListingsDependencies {
        let syncTVListings = services.tvListingsFactory.makeSyncTVListingsUseCase()
        let fetchTVChannels = services.tvListingsFactory.makeFetchTVChannelsUseCase()
        let fetchNowPlayingTVProgrammes = services.tvListingsFactory.makeFetchNowPlayingTVProgrammesUseCase()

        return TVListingsDependencies(
            sync: {
                try await syncTVListings.execute()
            },
            fetchChannels: {
                try await fetchTVChannels.execute()
            },
            fetchNowPlayingProgrammes: {
                try await fetchNowPlayingTVProgrammes.execute()
            }
        )
    }

}

#if DEBUG
    public extension TVListingsDependencies {

        /// Mock dependencies for previews and snapshot tests (mirrors the former
        /// `TVListingsClient.previewValue`).
        static var preview: TVListingsDependencies {
            TVListingsDependencies(
                sync: {},
                fetchChannels: { [] },
                fetchNowPlayingProgrammes: { [] }
            )
        }

    }
#endif
