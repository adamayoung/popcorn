//
//  PopcornTVListingsAdaptersFactory.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData
import TVListingsComposition
import TVListingsInfrastructure

public final class PopcornTVListingsAdaptersFactory: Sendable {

    private let session: URLSession
    private let epgURL: URL
    private let now: @Sendable () -> Date
    private let modelContainer: ModelContainer?

    public init(
        session: URLSession = HTTPTVListingsRemoteDataSource.defaultURLSession,
        epgURL: URL = HTTPTVListingsRemoteDataSource.defaultEPGURL,
        now: @escaping @Sendable () -> Date = { .now },
        modelContainer: ModelContainer? = nil
    ) {
        self.session = session
        self.epgURL = epgURL
        self.now = now
        self.modelContainer = modelContainer
    }

    public func makeTVListingsFactory() -> LivePopcornTVListingsFactory {
        let remoteDataSource = HTTPTVListingsRemoteDataSource(
            session: session,
            epgURL: epgURL,
            now: now
        )
        if let modelContainer {
            return LivePopcornTVListingsFactory(
                remoteDataSource: remoteDataSource,
                modelContainer: modelContainer
            )
        }
        return LivePopcornTVListingsFactory(remoteDataSource: remoteDataSource)
    }

}
