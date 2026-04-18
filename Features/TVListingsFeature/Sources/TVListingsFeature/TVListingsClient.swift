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

@DependencyClient
struct TVListingsClient {

    var sync: @Sendable () async throws -> Void

}

extension TVListingsClient: DependencyKey {

    static var liveValue: TVListingsClient {
        @Dependency(\.syncTVListings) var syncTVListings

        return TVListingsClient(
            sync: {
                try await syncTVListings.execute()
            }
        )
    }

    static var previewValue: TVListingsClient {
        TVListingsClient(
            sync: {}
        )
    }

}

extension DependencyValues {

    var tvListingsClient: TVListingsClient {
        get { self[TVListingsClient.self] }
        set { self[TVListingsClient.self] = newValue }
    }

}
