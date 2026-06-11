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
    private let baseURL: URL

    public init(
        session: URLSession = HTTPTVListingsRemoteDataSource.defaultURLSession,
        baseURL: URL = HTTPTVListingsRemoteDataSource.defaultEPGBaseURL
    ) {
        self.session = session
        self.baseURL = baseURL
    }

    public func makeRemoteDataSource() -> some TVListingsRemoteDataSource {
        HTTPTVListingsRemoteDataSource(session: session, baseURL: baseURL)
    }

}
