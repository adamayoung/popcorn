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

    let epgURL: URL

    /// Fixture programmes start at 1_776_461_400. Using a date before that keeps
    /// every programme from being filtered as "already finished".
    let beforeFixture = Date(timeIntervalSince1970: 1_776_461_000)

    init() throws {
        self.epgURL = try #require(URL(string: "https://example.invalid/epg.json"))
        URLProtocolStub.setHandler(nil)
    }

    @Test("fetchListings returns snapshot on 200 with valid JSON")
    func fetchListingsReturnsSnapshotOn200() async throws {
        let fixtureData = try FixtureLoader.data(named: "epg-sample")
        let capturedURL = epgURL
        URLProtocolStub.setHandler { _ in
            let response = try makeHTTPResponse(url: capturedURL, statusCode: 200)
            return (response, fixtureData)
        }
        let referenceDate = beforeFixture
        let dataSource = HTTPTVListingsRemoteDataSource(
            session: URLProtocolStub.session(),
            epgURL: epgURL,
            now: { referenceDate }
        )

        let snapshot = try await dataSource.fetchListings()

        #expect(snapshot.channels.count == 2)
        #expect(snapshot.programmes.count == 4)
    }

    @Test("fetchListings filters out finished programmes using injected now")
    func fetchListingsFiltersOutFinishedProgrammes() async throws {
        let fixtureData = try FixtureLoader.data(named: "epg-sample")
        let capturedURL = epgURL
        URLProtocolStub.setHandler { _ in
            let response = try makeHTTPResponse(url: capturedURL, statusCode: 200)
            return (response, fixtureData)
        }
        // Reference between fixture end-times filters the earliest pair.
        let midFixture = Date(timeIntervalSince1970: 1_776_464_000)
        let dataSource = HTTPTVListingsRemoteDataSource(
            session: URLProtocolStub.session(),
            epgURL: epgURL,
            now: { midFixture }
        )

        let snapshot = try await dataSource.fetchListings()

        #expect(snapshot.programmes.count == 2)
        #expect(snapshot.programmes.allSatisfy { $0.endTime > midFixture })
    }

    @Test("fetchListings throws decoding on 200 with malformed JSON")
    func fetchListingsThrowsDecodingOn200WithMalformedJSON() async {
        let capturedURL = epgURL
        URLProtocolStub.setHandler { _ in
            let response = try makeHTTPResponse(url: capturedURL, statusCode: 200)
            return (response, Data("not-json".utf8))
        }
        let dataSource = HTTPTVListingsRemoteDataSource(
            session: URLProtocolStub.session(),
            epgURL: epgURL
        )

        await #expect(
            performing: {
                _ = try await dataSource.fetchListings()
            },
            throws: { error in
                guard let error = error as? TVListingsRemoteDataSourceError else {
                    return false
                }
                if case .decoding = error {
                    return true
                }
                return false
            }
        )
    }

    @Test("fetchListings throws network when URLSession fails")
    func fetchListingsThrowsNetworkWhenSessionFails() async {
        URLProtocolStub.setHandler { _ in
            throw URLError(.notConnectedToInternet)
        }
        let dataSource = HTTPTVListingsRemoteDataSource(
            session: URLProtocolStub.session(),
            epgURL: epgURL
        )

        await #expect(
            performing: {
                _ = try await dataSource.fetchListings()
            },
            throws: { error in
                guard let error = error as? TVListingsRemoteDataSourceError else {
                    return false
                }
                if case .network = error {
                    return true
                }
                return false
            }
        )
    }

    @Test("fetchListings throws network on non-2xx HTTP status")
    func fetchListingsThrowsNetworkOnNon2xxStatus() async {
        let capturedURL = epgURL
        URLProtocolStub.setHandler { _ in
            let response = try makeHTTPResponse(url: capturedURL, statusCode: 503)
            return (response, Data())
        }
        let dataSource = HTTPTVListingsRemoteDataSource(
            session: URLProtocolStub.session(),
            epgURL: epgURL
        )

        await #expect(
            performing: {
                _ = try await dataSource.fetchListings()
            },
            throws: { error in
                guard let error = error as? TVListingsRemoteDataSourceError else {
                    return false
                }
                if case .network = error {
                    return true
                }
                return false
            }
        )
    }

}

private func makeHTTPResponse(url: URL, statusCode: Int) throws -> HTTPURLResponse {
    if let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil) {
        return response
    }
    throw URLError(.badServerResponse)
}
