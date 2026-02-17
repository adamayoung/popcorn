//
//  StubDiscoverTVSeriesRepository.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2026 Adam Young.
//

import DiscoverDomain
import Foundation

public final class StubDiscoverTVSeriesRepository: DiscoverTVSeriesRepository, Sendable {

    public init() {}

    public func tvSeries(
        filter: TVSeriesFilter?,
        page: Int
    ) async throws(DiscoverTVSeriesRepositoryError) -> [TVSeriesPreview] {
        Self.stubTVSeries
    }

}

extension StubDiscoverTVSeriesRepository {

    // TV Series IDs must match TVSeriesUITesting.StubTVSeriesRepository for full details to load
    // swiftlint:disable line_length
    private static let stubTVSeries: [TVSeriesPreview] = [
        TVSeriesPreview(
            id: 66732,
            name: "Stranger Things",
            overview: "When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces, and one strange little girl.",
            firstAirDate: date(year: 2016, month: 7, day: 15),
            genreIDs: [10765, 9648, 10759],
            posterPath: URL(string: "/uOOtwVbSr4QDjAGIifLDwpb2Pdl.jpg"),
            backdropPath: URL(string: "/8zbAoryWbtH0DKdev8abFAjdufy.jpg")
        ),
        TVSeriesPreview(
            id: 95479,
            name: "Jujutsu Kaisen",
            overview: "Yuji Itadori is a boy with tremendous physical strength, though he lives a completely ordinary high school life.",
            firstAirDate: date(year: 2020, month: 10, day: 3),
            genreIDs: [16, 10759, 10765],
            posterPath: URL(string: "/fHpKWq9ayzSk8nSwqRuaAUemRKh.jpg"),
            backdropPath: URL(string: "/gmECX1DvFgdUPjtio2zaL8BPYPu.jpg")
        ),
        TVSeriesPreview(
            id: 106_379,
            name: "Fallout",
            overview: "The story of haves and have-nots in a world in which there's almost nothing left to have.",
            firstAirDate: date(year: 2024, month: 4, day: 10),
            genreIDs: [10759, 10765],
            posterPath: URL(string: "/c15BtJxCXMrISLVmysdsnZUPQft.jpg"),
            backdropPath: URL(string: "/coaPCIqQBPUZsOnJcWZxhaORcDT.jpg")
        ),
        TVSeriesPreview(
            id: 37854,
            name: "One Piece",
            overview: "Years ago, the fearsome Pirate King, Gol D. Roger was executed leaving a huge pile of treasure and the famous \"One Piece\" behind.",
            firstAirDate: date(year: 1999, month: 10, day: 20),
            genreIDs: [10759, 35, 16],
            posterPath: URL(string: "/cMD9Ygz11zjJzAovURpO75Qg7rT.jpg"),
            backdropPath: URL(string: "/oVfucXvhutTpYExG9k06NJqnpT9.jpg")
        ),
        TVSeriesPreview(
            id: 103_540,
            name: "Percy Jackson and the Olympians",
            overview: "Percy Jackson is on a dangerous quest. Outrunning monsters and outwitting gods.",
            firstAirDate: date(year: 2023, month: 12, day: 19),
            genreIDs: [10759, 10765, 18, 10751],
            posterPath: URL(string: "/40eFcTzZier3DWLqldsP5VHxeoD.jpg"),
            backdropPath: URL(string: "/sAxx25ijwYQ8xsT56wu2IzvIRss.jpg")
        ),
        TVSeriesPreview(
            id: 79744,
            name: "The Rookie",
            overview: "Starting over isn't easy, especially for small-town guy John Nolan who, after a life-altering incident, is pursuing his dream of being an LAPD officer.",
            firstAirDate: date(year: 2018, month: 10, day: 16),
            genreIDs: [80, 18, 35],
            posterPath: URL(string: "/70kTz0OmjjZe7zHvIDrq2iKW7PJ.jpg"),
            backdropPath: URL(string: "/6iNWfGVCEfASDdlNb05TP5nG0ll.jpg")
        ),
        TVSeriesPreview(
            id: 157_741,
            name: "Landman",
            overview: "Set in the proverbial boomtowns of West-Texas and a modern-day tale of fortune-seeking in the world of oil rigs.",
            firstAirDate: date(year: 2024, month: 11, day: 17),
            genreIDs: [18],
            posterPath: URL(string: "/hYthRgS1nvQkGILn9YmqsF8kSk6.jpg"),
            backdropPath: URL(string: "/q71au2YjcwXBMZKNzNgjK7RZ3Hs.jpg")
        ),
        TVSeriesPreview(
            id: 200_875,
            name: "IT: Welcome to Derry",
            overview: "In 1962, amid a spate of unexplained disappearances of local children, a group of misfit friends begin to suspect a long-buried ancient evil lurking.",
            firstAirDate: date(year: 2025, month: 10, day: 26),
            genreIDs: [18, 9648],
            posterPath: URL(string: "/nyy3BITeIjviv6PFIXtqvc8i6xi.jpg"),
            backdropPath: URL(string: "/2fOKVDoc2O3eZmBZesWPuE5kgPN.jpg")
        )
    ]
    // swiftlint:enable line_length

    private static func date(year: Int, month: Int, day: Int) -> Date {
        DateComponents(calendar: .current, year: year, month: month, day: day).date ?? .now
    }

}
