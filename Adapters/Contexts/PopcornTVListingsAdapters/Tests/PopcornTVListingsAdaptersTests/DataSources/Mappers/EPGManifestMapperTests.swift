//
//  EPGManifestMapperTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTVListingsAdapters
import Testing
import TVListingsInfrastructure

@Suite("EPGManifestMapper")
struct EPGManifestMapperTests {

    let mapper = EPGManifestMapper()

    @Test("maps dates and files and exposes file accessors")
    func mapsDatesAndFiles() {
        let dto = EPGManifestDTO(
            generatedAt: "2026-06-11T06:00:00.000Z",
            dates: ["20260611", "20260612"],
            files: [
                EPGManifestFileDTO(path: "channels.json", hash: "c1", bytes: 10),
                EPGManifestFileDTO(path: "schedules/20260611.json", hash: "s1", bytes: 20)
            ]
        )

        let manifest = mapper.map(dto)

        #expect(manifest.dates == ["20260611", "20260612"])
        #expect(manifest.channelsFile?.hash == "c1")
        #expect(manifest.scheduleFile(forDate: "20260611")?.hash == "s1")
        #expect(manifest.scheduleFile(forDate: "20260612") == nil)
    }

    @Test("parses fractional-second timestamps")
    func parsesFractionalSeconds() {
        let dto = EPGManifestDTO(generatedAt: "2026-06-11T06:00:00.500Z", dates: [], files: [])

        let manifest = mapper.map(dto)

        #expect(manifest.generatedAt == utcDate(2026, 6, 11, 6, 0).addingTimeInterval(0.5))
    }

    @Test("parses non-fractional timestamps")
    func parsesNonFractionalSeconds() {
        let dto = EPGManifestDTO(generatedAt: "2026-06-11T06:00:00Z", dates: [], files: [])

        let manifest = mapper.map(dto)

        #expect(manifest.generatedAt == utcDate(2026, 6, 11, 6, 0))
    }

    @Test("falls back to a sentinel date for an unparseable timestamp")
    func fallsBackForUnparseableTimestamp() {
        let dto = EPGManifestDTO(generatedAt: "not-a-date", dates: [], files: [])

        let manifest = mapper.map(dto)

        #expect(manifest.generatedAt == Date(timeIntervalSince1970: 0))
    }

    private func utcDate(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = 0
        components.timeZone = TimeZone(identifier: "UTC")
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC") ?? .current
        return calendar.date(from: components) ?? .distantPast
    }

}
