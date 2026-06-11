//
//  HTTPTVListingsRemoteDataSourceTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTVListingsAdapters
import Testing
import TVListingsInfrastructure

@Suite("HTTPTVListingsRemoteDataSource", .serialized)
struct HTTPTVListingsRemoteDataSourceTests {

    let baseURL: URL

    init() throws {
        self.baseURL = try #require(URL(string: "https://example.invalid"))
        URLProtocolStub.setHandler(nil)
    }

    @Test("fetchManifest requests manifest.json and maps the response")
    func fetchManifestMapsResponse() async throws {
        let fixture = try FixtureLoader.data(named: "manifest")
        let requestedPath = LockedBox<String?>(nil)
        URLProtocolStub.setHandler { request in
            requestedPath.value = request.url?.path
            return try (ok(request), fixture)
        }

        let manifest = try await makeDataSource().fetchManifest()

        #expect(requestedPath.value == "/manifest.json")
        #expect(manifest.dates == ["20260418", "20260419"])
        #expect(manifest.channelsFile?.hash == "channels-hash-1")
        #expect(manifest.scheduleFile(forDate: "20260418")?.hash == "schedule-418-hash")
    }

    @Test("fetchChannels requests channels.json and maps channels")
    func fetchChannelsMapsResponse() async throws {
        let fixture = try FixtureLoader.data(named: "channels")
        let requestedPath = LockedBox<String?>(nil)
        URLProtocolStub.setHandler { request in
            requestedPath.value = request.url?.path
            return try (ok(request), fixture)
        }

        let channels = try await makeDataSource().fetchChannels()

        #expect(requestedPath.value == "/channels.json")
        #expect(channels.map(\.id) == ["3858", "4011"])
        #expect(channels.first?.channelNumbers.first?.channelNumber == "1081")
    }

    @Test("fetchSchedule requests the dated path and maps enriched programmes")
    func fetchScheduleMapsResponse() async throws {
        let fixture = try FixtureLoader.data(named: "schedule-20260418")
        let requestedPath = LockedBox<String?>(nil)
        URLProtocolStub.setHandler { request in
            requestedPath.value = request.url?.path
            return try (ok(request), fixture)
        }

        let programmes = try await makeDataSource().fetchSchedule(forDate: "20260418")

        #expect(requestedPath.value == "/schedules/20260418.json")
        #expect(programmes.count == 3)
        let premiere = programmes.first { $0.title == "Back Pages Tonight" }
        #expect(premiere?.isPremiere == true)
        #expect(premiere?.genres == ["Sport", "News"])
        #expect(premiere?.certification == "U")
        #expect(premiere?.watchProviders == ["Sky Go", "Now TV"])
    }

    @Test("throws decoding on malformed JSON")
    func throwsDecodingOnMalformedJSON() async {
        URLProtocolStub.setHandler { request in try (ok(request), Data("not-json".utf8)) }

        await #expect(
            performing: { _ = try await makeDataSource().fetchManifest() },
            throws: { isError($0, .decoding) }
        )
    }

    @Test("throws network when the session fails")
    func throwsNetworkWhenSessionFails() async {
        URLProtocolStub.setHandler { _ in throw URLError(.notConnectedToInternet) }

        await #expect(
            performing: { _ = try await makeDataSource().fetchChannels() },
            throws: { isError($0, .network) }
        )
    }

    @Test("throws network on a non-2xx status")
    func throwsNetworkOnNon2xxStatus() async {
        URLProtocolStub.setHandler { request in
            try (makeHTTPResponse(url: request.url, statusCode: 503), Data())
        }

        await #expect(
            performing: { _ = try await makeDataSource().fetchSchedule(forDate: "20260418") },
            throws: { isError($0, .network) }
        )
    }

    // MARK: - Helpers

    private func makeDataSource() -> HTTPTVListingsRemoteDataSource {
        HTTPTVListingsRemoteDataSource(session: URLProtocolStub.session(), baseURL: baseURL)
    }

    private enum ErrorKind { case network, decoding }

    private func isError(_ error: any Error, _ kind: ErrorKind) -> Bool {
        guard let error = error as? TVListingsRemoteDataSourceError else {
            return false
        }
        switch (error, kind) {
        case (.network, .network), (.decoding, .decoding): return true
        default: return false
        }
    }

}

private func ok(_ request: URLRequest) throws -> HTTPURLResponse {
    try makeHTTPResponse(url: request.url, statusCode: 200)
}

private func makeHTTPResponse(url: URL?, statusCode: Int) throws -> HTTPURLResponse {
    if let url, let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil) {
        return response
    }
    throw URLError(.badServerResponse)
}

/// A minimal `@Sendable`-safe mutable box for capturing a value from the stub handler.
private final class LockedBox<Value>: @unchecked Sendable {
    private let lock = NSLock()
    private var stored: Value
    init(_ value: Value) {
        self.stored = value
    }

    var value: Value {
        get { lock.withLock { stored } }
        set { lock.withLock { stored = newValue } }
    }
}
