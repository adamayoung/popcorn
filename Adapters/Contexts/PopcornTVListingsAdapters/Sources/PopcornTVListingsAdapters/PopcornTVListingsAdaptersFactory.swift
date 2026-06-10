//
//  PopcornTVListingsAdaptersFactory.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsInfrastructure

public final class PopcornTVListingsAdaptersFactory: Sendable {

    private let session: URLSession
    private let epgURL: URL
    private let now: @Sendable () -> Date

    public init(
        session: URLSession = HTTPTVListingsRemoteDataSource.defaultURLSession,
        epgURL: URL = HTTPTVListingsRemoteDataSource.defaultEPGURL,
        now: @escaping @Sendable () -> Date = { .now }
    ) {
        self.session = session
        self.epgURL = epgURL
        self.now = now
    }

    public func makeRemoteDataSource() -> some TVListingsRemoteDataSource {
        HTTPTVListingsRemoteDataSource(session: session, epgURL: epgURL, now: now)
    }

}
