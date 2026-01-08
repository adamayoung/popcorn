//
//  StubTVSeriesRepository.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TVSeriesDomain

public final class StubTVSeriesRepository: TVSeriesRepository, Sendable {

    public init() {}

    public func tvSeries(withID id: Int) async throws(TVSeriesRepositoryError) -> TVSeries {
        guard let series = Self.tvSeriesData[id] else {
            throw .notFound
        }
        return series
    }

    public func images(forTVSeries tvSeriesID: Int) async throws(TVSeriesRepositoryError) -> ImageCollection {
        ImageCollection(
            id: tvSeriesID,
            posterPaths: [],
            backdropPaths: [],
            logoPaths: []
        )
    }

}

extension StubTVSeriesRepository {

    // swiftlint:disable line_length
    static let tvSeriesData: [Int: TVSeries] = [
        66732: TVSeries(
            id: 66732,
            name: "Stranger Things",
            tagline: "It only gets stranger...",
            overview: "When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces, and one strange little girl.",
            numberOfSeasons: 4,
            firstAirDate: DateComponents(calendar: .current, year: 2016, month: 7, day: 15).date,
            posterPath: URL(string: "/uOOtwVbSr4QDjAGIifLDwpb2Pdl.jpg"),
            backdropPath: URL(string: "/8zbAoryWbtH0DKdev8abFAjdufy.jpg")
        ),
        95479: TVSeries(
            id: 95479,
            name: "Jujutsu Kaisen",
            tagline: nil,
            overview: "Yuji Itadori is a boy with tremendous physical strength, though he lives a completely ordinary high school life. One day, to save a classmate who has been attacked by curses, he eats the finger of Ryomen Sukuna, taking the curse into his own soul.",
            numberOfSeasons: 2,
            firstAirDate: DateComponents(calendar: .current, year: 2020, month: 10, day: 3).date,
            posterPath: URL(string: "/fHpKWq9ayzSk8nSwqRuaAUemRKh.jpg"),
            backdropPath: URL(string: "/gmECX1DvFgdUPjtio2zaL8BPYPu.jpg")
        ),
        106_379: TVSeries(
            id: 106_379,
            name: "Fallout",
            tagline: "The end is just the beginning.",
            overview: "The story of haves and have-nots in a world in which there's almost nothing left to have. 200 years after the apocalypse, the gentle denizens of luxury fallout shelters are forced to return to the irradiated hellscape their ancestors left behind.",
            numberOfSeasons: 1,
            firstAirDate: DateComponents(calendar: .current, year: 2024, month: 4, day: 10).date,
            posterPath: URL(string: "/c15BtJxCXMrISLVmysdsnZUPQft.jpg"),
            backdropPath: URL(string: "/coaPCIqQBPUZsOnJcWZxhaORcDT.jpg")
        ),
        37854: TVSeries(
            id: 37854,
            name: "One Piece",
            tagline: nil,
            overview: "Years ago, the fearsome Pirate King, Gol D. Roger was executed leaving a huge pile of treasure and the famous \"One Piece\" behind. Whoever claims the \"One Piece\" will be named the new King of the Pirates.",
            numberOfSeasons: 21,
            firstAirDate: DateComponents(calendar: .current, year: 1999, month: 10, day: 20).date,
            posterPath: URL(string: "/cMD9Ygz11zjJzAovURpO75Qg7rT.jpg"),
            backdropPath: URL(string: "/oVfucXvhutTpYExG9k06NJqnpT9.jpg")
        ),
        103_540: TVSeries(
            id: 103_540,
            name: "Percy Jackson and the Olympians",
            tagline: nil,
            overview: "Percy Jackson is on a dangerous quest. Outrunning monsters and outwitting gods, he must journey across America to return Zeus's master bolt and stop an all-out war.",
            numberOfSeasons: 2,
            firstAirDate: DateComponents(calendar: .current, year: 2023, month: 12, day: 19).date,
            posterPath: URL(string: "/40eFcTzZier3DWLqldsP5VHxeoD.jpg"),
            backdropPath: URL(string: "/sAxx25ijwYQ8xsT56wu2IzvIRss.jpg")
        ),
        79744: TVSeries(
            id: 79744,
            name: "The Rookie",
            tagline: nil,
            overview: "Starting over isn't easy, especially for small-town guy John Nolan who, after a life-altering incident, is pursuing his dream of being an LAPD officer.",
            numberOfSeasons: 7,
            firstAirDate: DateComponents(calendar: .current, year: 2018, month: 10, day: 16).date,
            posterPath: URL(string: "/70kTz0OmjjZe7zHvIDrq2iKW7PJ.jpg"),
            backdropPath: URL(string: "/6iNWfGVCEfASDdlNb05TP5nG0ll.jpg")
        ),
        157_741: TVSeries(
            id: 157_741,
            name: "Landman",
            tagline: nil,
            overview: "Set in the proverbial boomtowns of West-Texas and a modern-day tale of fortune-seeking in the world of oil rigs.",
            numberOfSeasons: 1,
            firstAirDate: DateComponents(calendar: .current, year: 2024, month: 11, day: 17).date,
            posterPath: URL(string: "/hYthRgS1nvQkGILn9YmqsF8kSk6.jpg"),
            backdropPath: URL(string: "/q71au2YjcwXBMZKNzNgjK7RZ3Hs.jpg")
        ),
        200_875: TVSeries(
            id: 200_875,
            name: "IT: Welcome to Derry",
            tagline: nil,
            overview: "In 1962, amid a spate of unexplained disappearances of local children, a group of misfit friends begin to suspect a long-buried ancient evil lurking.",
            numberOfSeasons: 1,
            firstAirDate: DateComponents(calendar: .current, year: 2025, month: 10, day: 26).date,
            posterPath: URL(string: "/nyy3BITeIjviv6PFIXtqvc8i6xi.jpg"),
            backdropPath: URL(string: "/2fOKVDoc2O3eZmBZesWPuE5kgPN.jpg")
        )
    ]
    // swiftlint:enable line_length

}
