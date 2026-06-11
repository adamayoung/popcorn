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

    /// The hard-coded base origin of the EPG feed. There is no production override.
    public static let defaultEPGBaseURL = makeDefaultEPGBaseURL()

    ///
    /// Default session used when callers don't provide one. Bounded timeouts keep a stalled
    /// download from hanging, and a `URLCache` lets the CDN's `ETag`/`Cache-Control` headers
    /// serve unchanged files cheaply (the manifest is the only file fetched every sync).
    ///
    public static let defaultURLSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.urlCache = URLCache(
            memoryCapacity: 4 * 1024 * 1024,
            diskCapacity: 32 * 1024 * 1024
        )
        return URLSession(configuration: configuration)
    }()

    private static let logger = Logger(
        subsystem: "uk.co.adam-young.Popcorn.TVListings",
        category: "RemoteDataSource"
    )

    private let session: URLSession
    private let baseURL: URL
    private let manifestMapper = EPGManifestMapper()
    private let channelMapper = EPGChannelMapper()
    private let scheduleMapper = EPGScheduleMapper()

    public init(
        session: URLSession = HTTPTVListingsRemoteDataSource.defaultURLSession,
        baseURL: URL = HTTPTVListingsRemoteDataSource.defaultEPGBaseURL
    ) {
        self.session = session
        self.baseURL = baseURL
    }

    public func fetchManifest() async throws(TVListingsRemoteDataSourceError) -> EPGManifest {
        let dto: EPGManifestDTO = try await fetch(path: "manifest.json")
        return manifestMapper.map(dto)
    }

    public func fetchChannels() async throws(TVListingsRemoteDataSourceError) -> [TVChannel] {
        let dto: EPGChannelsResponseDTO = try await fetch(path: "channels.json")
        return dto.channels.map(channelMapper.map)
    }

    public func fetchSchedule(
        forDate date: String
    ) async throws(TVListingsRemoteDataSourceError) -> [TVProgramme] {
        // Validate at the boundary too (defence in depth): only a bare yyyyMMdd is safe to
        // interpolate into the request path, so a malformed value can't alter the URL.
        guard date.count == 8, date.allSatisfy(\.isNumber) else {
            Self.logger.error("Rejecting malformed schedule date: \(date, privacy: .public)")
            throw .network(nil)
        }
        let dto: EPGScheduleResponseDTO = try await fetch(path: "schedules/\(date).json")
        return scheduleMapper.map(dto)
    }

    private func fetch<Response: Decodable>(
        path: String
    ) async throws(TVListingsRemoteDataSourceError) -> Response {
        let url = baseURL.appending(path: path)

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(from: url)
        } catch let error {
            Self.logger.error(
                "Failed to fetch \(path, privacy: .public): \(error.localizedDescription, privacy: .public)"
            )
            throw .network(error)
        }

        // The feed is always HTTPS, so a non-HTTP response is itself a network failure
        // rather than something to forward to the decoder.
        guard let httpResponse = response as? HTTPURLResponse else {
            Self.logger.error("Fetch of \(path, privacy: .public) returned a non-HTTP response")
            throw .network(nil)
        }
        guard (200 ..< 300).contains(httpResponse.statusCode) else {
            Self.logger.error(
                "Fetch of \(path, privacy: .public) returned HTTP \(httpResponse.statusCode, privacy: .public)"
            )
            throw .network(nil)
        }

        do {
            return try JSONDecoder().decode(Response.self, from: data)
        } catch let error {
            Self.logger.error(
                "Failed to decode \(path, privacy: .public): \(error.localizedDescription, privacy: .public)"
            )
            throw .decoding(error)
        }
    }

}

private func makeDefaultEPGBaseURL() -> URL {
    let urlString = "https://epg.adam-young.co.uk"
    if let url = URL(string: urlString) {
        return url
    }
    preconditionFailure("Invalid default EPG base URL literal: \(urlString)")
}
