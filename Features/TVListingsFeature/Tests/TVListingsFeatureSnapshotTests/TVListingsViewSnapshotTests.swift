//
//  TVListingsViewSnapshotTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Presentation
import SnapshotTestHelpers
import SwiftUI
import Testing
import TVListingsDomain
@testable import TVListingsFeature

@Suite("TVListingsViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct TVListingsViewSnapshotTests {

    @Test
    func grid() {
        let view = NavigationStack {
            TVListingsView(
                viewModel: .preview(viewState: .ready(Self.deterministicSnapshot)),
                disableAutoScroll: true
            )
        }

        verifyViewSnapshot(of: view)
    }

    @Test
    func empty() {
        let now = Self.fixedNow
        let snapshot = TVListingsGridSnapshot(
            rows: [],
            geometry: .flooringNow(now),
            now: now
        )
        let view = NavigationStack {
            TVListingsView(
                viewModel: .preview(viewState: .ready(snapshot)),
                disableAutoScroll: true
            )
        }

        verifyViewSnapshot(of: view)
    }

    @Test
    func error() {
        let view = NavigationStack {
            TVListingsView(
                viewModel: .preview(viewState: .error(ViewStateError(message: "Something went wrong"))),
                disableAutoScroll: true
            )
        }

        verifyViewSnapshot(of: view)
    }

    // MARK: - Deterministic fixtures

    /// A fixed reference instant so the geometry/origin and airing/progress are
    /// stable across runs. 2026-06-11 20:10:00 UTC.
    static let fixedNow = Date(timeIntervalSince1970: 1_781_309_400)

    static var deterministicSnapshot: TVListingsGridSnapshot {
        let now = fixedNow
        let geometry = TimelineGeometry.flooringNow(now)
        let origin = geometry.origin

        // BBC One: an in-progress programme (started before origin), then a gap,
        // then a future programme.
        let inProgress = makeProgramme(
            channelID: "BBC_ONE",
            title: "The Six O'Clock News",
            start: origin.addingTimeInterval(-20 * 60),
            end: origin.addingTimeInterval(25 * 60),
            genre: "News"
        )
        let future = makeProgramme(
            channelID: "BBC_ONE",
            title: "Drama of the Week",
            // Gap between 25 and 60 minutes after origin.
            start: origin.addingTimeInterval(60 * 60),
            end: origin.addingTimeInterval(120 * 60),
            genre: "Drama"
        )

        // ITV1: a narrow block (short duration) followed by a longer one.
        let narrow = makeProgramme(
            channelID: "ITV1",
            title: "Weather",
            start: origin,
            end: origin.addingTimeInterval(5 * 60),
            genre: "Weather"
        )
        let afterNarrow = makeProgramme(
            channelID: "ITV1",
            title: "Coronation Street",
            start: origin.addingTimeInterval(5 * 60),
            end: origin.addingTimeInterval(65 * 60),
            genre: "Soap"
        )

        return TVListingsGridSnapshot(
            rows: [
                makeRow(
                    channel: makeChannel(id: "BBC_ONE", name: "BBC One", number: "101"),
                    programmes: [inProgress, future],
                    now: now
                ),
                makeRow(
                    channel: makeChannel(id: "ITV1", name: "ITV1", number: "103"),
                    programmes: [narrow, afterNarrow],
                    now: now
                ),
                // An empty channel — no programmes.
                makeRow(
                    channel: makeChannel(id: "CHANNEL_4", name: "Channel 4", number: "104"),
                    programmes: [],
                    now: now
                )
            ],
            geometry: geometry,
            now: now
        )
    }

    private static func makeChannel(id: String, name: String, number: String) -> TVChannel {
        TVChannel(
            id: id,
            name: name,
            isHD: true,
            // No logo URL forces the deterministic initials path (no async load).
            logoURL: nil,
            channelNumbers: [TVChannelNumber(channelNumber: number, subbouquetIDs: [])]
        )
    }

    private static func makeProgramme(
        channelID: String,
        title: String,
        start: Date,
        end: Date,
        genre: String
    ) -> TVProgramme {
        TVProgramme(
            id: TVProgramme.makeID(channelID: channelID, startTime: start),
            channelID: channelID,
            title: title,
            description: "",
            startTime: start,
            endTime: end,
            duration: end.timeIntervalSince(start),
            episodeNumber: nil,
            seasonNumber: nil,
            imageURL: nil,
            tmdbTVSeriesID: nil,
            tmdbMovieID: nil,
            genres: [genre]
        )
    }

    private static func makeRow(
        channel: TVChannel,
        programmes: [TVProgramme],
        now: Date
    ) -> TVListingsChannelRow {
        let items = programmes
            .sorted { $0.startTime < $1.startTime }
            .map { programme -> TVListingsProgrammeItem in
                let isAiringNow = programme.startTime <= now && now < programme.endTime
                let progress: Double = {
                    guard isAiringNow, programme.duration > 0 else {
                        return 0
                    }
                    let elapsed = now.timeIntervalSince(programme.startTime)
                    return min(1, max(0, elapsed / programme.duration))
                }()
                return TVListingsProgrammeItem(
                    programme: programme,
                    isAiringNow: isAiringNow,
                    genre: programme.genres.first,
                    progress: progress
                )
            }
        return TVListingsChannelRow(channel: channel, programmes: items)
    }

}
