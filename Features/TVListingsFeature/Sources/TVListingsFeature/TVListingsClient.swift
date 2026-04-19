//
//  TVListingsClient.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import TVListingsApplication
import TVListingsDomain

@DependencyClient
struct TVListingsClient {

    var sync: @Sendable () async throws -> Void
    var fetchChannels: @Sendable () async throws -> [TVChannel]
    var fetchNowPlayingProgrammes: @Sendable () async throws -> [TVProgramme]

}

extension TVListingsClient: DependencyKey {

    static var liveValue: TVListingsClient {
        @Dependency(\.syncTVListings) var syncTVListings
        @Dependency(\.fetchTVChannels) var fetchTVChannels
        @Dependency(\.fetchNowPlayingTVProgrammes) var fetchNowPlayingTVProgrammes

        return TVListingsClient(
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

    static var previewValue: TVListingsClient {
        TVListingsClient(
            sync: {},
            fetchChannels: { [] },
            fetchNowPlayingProgrammes: { [] }
        )
    }

}

extension DependencyValues {

    var tvListingsClient: TVListingsClient {
        get { self[TVListingsClient.self] }
        set { self[TVListingsClient.self] = newValue }
    }

}
