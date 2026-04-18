//
//  HTTPTVListingsRemoteDataSource.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import OSLog
import TVListingsDomain
import TVListingsInfrastructure

public final class HTTPTVListingsRemoteDataSource: TVListingsRemoteDataSource {

    public static let defaultEPGURL = makeDefaultEPGURL()

    ///
    /// Default session used when callers don't provide one. Bounded timeouts keep a stalled
    /// download from hanging for the 7-day resource default on `URLSession.shared`.
    ///
    public static let defaultURLSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration)
    }()

    private static let logger = Logger(
        subsystem: "uk.co.adam-young.Popcorn.TVListings",
        category: "RemoteDataSource"
    )

    private let session: URLSession
    private let epgURL: URL
    private let now: @Sendable () -> Date
    private let mapper = EPGSnapshotMapper()

    public init(
        session: URLSession = HTTPTVListingsRemoteDataSource.defaultURLSession,
        epgURL: URL = HTTPTVListingsRemoteDataSource.defaultEPGURL,
        now: @escaping @Sendable () -> Date = { .now }
    ) {
        self.session = session
        self.epgURL = epgURL
        self.now = now
    }

    public func fetchListings() async throws(TVListingsRemoteDataSourceError) -> TVListingsSnapshot {
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(from: epgURL)
        } catch let error {
            Self.logger.error(
                "Failed to fetch EPG: \(error.localizedDescription, privacy: .public)"
            )
            throw .network(error)
        }

        if let httpResponse = response as? HTTPURLResponse {
            guard (200 ..< 300).contains(httpResponse.statusCode) else {
                Self.logger.error(
                    "EPG fetch returned HTTP status \(httpResponse.statusCode, privacy: .public)"
                )
                throw .network(nil)
            }
        }

        let decoded: EPGResponseDTO
        do {
            decoded = try JSONDecoder().decode(EPGResponseDTO.self, from: data)
        } catch let error {
            Self.logger.error(
                "Failed to decode EPG: \(error.localizedDescription, privacy: .public)"
            )
            throw .decoding(error)
        }

        return mapper.map(decoded, referenceDate: now())
    }

}

private func makeDefaultEPGURL() -> URL {
    let urlString = "https://raw.githubusercontent.com/adamayoung/popcorn-epg/refs/heads/main/epg.json"
    if let url = URL(string: urlString) {
        return url
    }
    preconditionFailure("Invalid default EPG URL literal: \(urlString)")
}
