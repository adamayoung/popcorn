//
//  EPGSnapshotMapperTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTVListingsAdapters
import Testing
import TVListingsDomain

@Suite("EPGSnapshotMapper")
struct EPGSnapshotMapperTests {

    let mapper = EPGSnapshotMapper()

    /// Epoch of fixture's earliest programme startTime is 1_776_461_400. A reference
    /// earlier than that keeps every programme; use this for non-filtering assertions.
    let beforeFixture = Date(timeIntervalSince1970: 1_776_461_000)

    @Test("flattens all programmes across all channels and schedule days")
    func flattensAllProgrammesAcrossChannelsAndDays() throws {
        let data = try FixtureLoader.data(named: "epg-sample")
        let decoded = try JSONDecoder().decode(EPGResponseDTO.self, from: data)

        let snapshot = mapper.map(decoded, referenceDate: beforeFixture)

        #expect(snapshot.channels.count == 2)
        #expect(snapshot.programmes.count == 4)
    }

    @Test("maps channels preserving order")
    func mapsChannelsPreservingOrder() throws {
        let data = try FixtureLoader.data(named: "epg-sample")
        let decoded = try JSONDecoder().decode(EPGResponseDTO.self, from: data)

        let snapshot = mapper.map(decoded, referenceDate: beforeFixture)

        #expect(snapshot.channels.map(\.id) == ["3858", "4011"])
    }

    @Test("programmes use their channel's sid as channelID")
    func programmesUseTheirChannelsSidAsChannelID() throws {
        let data = try FixtureLoader.data(named: "epg-sample")
        let decoded = try JSONDecoder().decode(EPGResponseDTO.self, from: data)

        let snapshot = mapper.map(decoded, referenceDate: beforeFixture)

        let forSky = snapshot.programmes.filter { $0.channelID == "3858" }
        let forPL = snapshot.programmes.filter { $0.channelID == "4011" }
        #expect(forSky.count == 2)
        #expect(forPL.count == 2)
    }

    @Test("programme ids are unique across the snapshot")
    func programmeIDsAreUniqueAcrossTheSnapshot() throws {
        let data = try FixtureLoader.data(named: "epg-sample")
        let decoded = try JSONDecoder().decode(EPGResponseDTO.self, from: data)

        let snapshot = mapper.map(decoded, referenceDate: beforeFixture)

        let ids = Set(snapshot.programmes.map(\.id))
        #expect(ids.count == snapshot.programmes.count)
    }

    @Test("empty response produces empty snapshot")
    func emptyResponseProducesEmptySnapshot() throws {
        let response = try JSONDecoder().decode(EPGResponseDTO.self, from: Data(#"{"channels":[]}"#.utf8))

        let snapshot = mapper.map(response, referenceDate: beforeFixture)

        #expect(snapshot.channels.isEmpty)
        #expect(snapshot.programmes.isEmpty)
    }

    // MARK: - Finished-programme filtering

    @Test("excludes programmes whose end time is at or before the reference date")
    func excludesProgrammesWhoseEndTimeIsAtOrBeforeTheReferenceDate() throws {
        let data = try FixtureLoader.data(named: "epg-sample")
        let decoded = try JSONDecoder().decode(EPGResponseDTO.self, from: data)

        // Reference date between fixture programme end times (1_776_463_200 and 1_776_466_800).
        // Expectation: programmes with endTime == 1_776_463_200 are filtered; two survive.
        let midFixture = Date(timeIntervalSince1970: 1_776_464_000)

        let snapshot = mapper.map(decoded, referenceDate: midFixture)

        #expect(snapshot.programmes.count == 2)
        #expect(snapshot.programmes.allSatisfy { $0.endTime > midFixture })
    }

    // MARK: - Duplicate programme handling

    @Test("deduplicates programmes that share the same composite ID")
    func deduplicatesProgrammesThatShareTheSameCompositeID() throws {
        let json = """
        {
          "channels": [{
            "sid": "3858",
            "name": "Sky",
            "isHD": false,
            "channelNumbers": [],
            "schedules": [{
              "date": "20260418",
              "programmes": [
                {"title": "Show", "startTime": 1776461400, "duration": 1800},
                {"title": "Show (dup)", "startTime": 1776461400, "duration": 1800}
              ]
            }]
          }]
        }
        """
        let response = try JSONDecoder().decode(EPGResponseDTO.self, from: Data(json.utf8))

        let snapshot = mapper.map(response, referenceDate: beforeFixture)

        #expect(snapshot.programmes.count == 1)
        #expect(snapshot.programmes.first?.title == "Show")
    }

    @Test("keeps channels whose only programmes have already finished")
    func keepsChannelsWhoseOnlyProgrammesHaveFinished() throws {
        let data = try FixtureLoader.data(named: "epg-sample")
        let decoded = try JSONDecoder().decode(EPGResponseDTO.self, from: data)

        // Far-future reference: every fixture programme is finished.
        let farFuture = Date(timeIntervalSince1970: 2_000_000_000)

        let snapshot = mapper.map(decoded, referenceDate: farFuture)

        #expect(snapshot.channels.count == 2)
        #expect(snapshot.programmes.isEmpty)
    }

}
