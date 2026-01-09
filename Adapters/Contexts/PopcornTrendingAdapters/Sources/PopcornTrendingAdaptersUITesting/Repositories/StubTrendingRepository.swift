//
//  StubTrendingRepository.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import TrendingDomain

public final class StubTrendingRepository: TrendingRepository, Sendable {

    public init() {}

    public func movies(page: Int) async throws(TrendingRepositoryError) -> [MoviePreview] {
        Self.trendingMovies
    }

    public func tvSeries(page: Int) async throws(TrendingRepositoryError) -> [TVSeriesPreview] {
        Self.trendingTVSeries
    }

    public func people(page: Int) async throws(TrendingRepositoryError) -> [PersonPreview] {
        Self.trendingPeople
    }

}

extension StubTrendingRepository {

    // Movies that match IDs from MoviesUITesting.StubMovieRepository
    // swiftlint:disable line_length
    static let trendingMovies: [MoviePreview] = [
        MoviePreview(
            id: 1_242_898,
            title: "Predator: Badlands",
            overview: "When a Predator descends upon the distant world of Arcadia, bounty hunter Thia must survive the hunt.",
            posterPath: URL(string: "/j8id6sRxkzFSqKFuxnKYd0FR7PA.jpg"),
            backdropPath: URL(string: "/xsgg79pzd8LfFbVZx3gcdNt5Wdy.jpg")
        ),
        MoviePreview(
            id: 83533,
            title: "Avalanche Sharks",
            overview: "A group of friends, vacationing at a ski resort, are hunted by prehistoric sharks in the snow.",
            posterPath: URL(string: "/wGUkjFEnGUWINJwRgx5Lbny95Pr.jpg"),
            backdropPath: URL(string: "/l50B3CY0aF8fDFQeDLsJrdQVJLF.jpg")
        ),
        MoviePreview(
            id: 1_084_242,
            title: "Zootopia 2",
            overview: "Judy and Nick take on a dangerous case that will test their partnership like never before.",
            posterPath: URL(string: "/pmfqMSiJT2mPmXPjlmsmFqPtB5T.jpg"),
            backdropPath: URL(string: "/6SuM8bq7TY33D4VH5nqxWKZAqXz.jpg")
        ),
        MoviePreview(
            id: 533_533,
            title: "Deadpool & Wolverine",
            overview: "Deadpool teams up with Wolverine to save the multiverse.",
            posterPath: URL(string: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg"),
            backdropPath: URL(string: "/yDHYTfA3R0jFYba16jBB1ef8oIt.jpg")
        ),
        MoviePreview(
            id: 1_252_037,
            title: "Now You See Me 3",
            overview: "The Four Horsemen reunite for an explosive new adventure.",
            posterPath: URL(string: "/cFGfpGhVPt2zBT3hMwsGPrBd9JB.jpg"),
            backdropPath: URL(string: "/xt4BxNvGM1SVyNzXKjBFf9sTgdI.jpg")
        ),
        MoviePreview(
            id: 812_583,
            title: "Win or Lose",
            overview: "A coming-of-age Pixar story following a group of kids during a softball game.",
            posterPath: URL(string: "/5qqvuPBBpcJ6xfvKTUX8J1Pcp2D.jpg"),
            backdropPath: URL(string: "/z0cLHEFGRqD9pSLLBfyqzfKDXEk.jpg")
        )
    ]

    // TV Series that match IDs from TVSeriesUITesting.StubTVSeriesRepository
    static let trendingTVSeries: [TVSeriesPreview] = [
        TVSeriesPreview(
            id: 66732,
            name: "Stranger Things",
            overview: "When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces, and one strange little girl.",
            posterPath: URL(string: "/uOOtwVbSr4QDjAGIifLDwpb2Pdl.jpg"),
            backdropPath: URL(string: "/8zbAoryWbtH0DKdev8abFAjdufy.jpg")
        ),
        TVSeriesPreview(
            id: 95479,
            name: "Jujutsu Kaisen",
            overview: "Yuji Itadori is a boy with tremendous physical strength, though he lives a completely ordinary high school life.",
            posterPath: URL(string: "/fHpKWq9ayzSk8nSwqRuaAUemRKh.jpg"),
            backdropPath: URL(string: "/gmECX1DvFgdUPjtio2zaL8BPYPu.jpg")
        ),
        TVSeriesPreview(
            id: 106_379,
            name: "Fallout",
            overview: "The story of haves and have-nots in a world in which there's almost nothing left to have.",
            posterPath: URL(string: "/c15BtJxCXMrISLVmysdsnZUPQft.jpg"),
            backdropPath: URL(string: "/coaPCIqQBPUZsOnJcWZxhaORcDT.jpg")
        ),
        TVSeriesPreview(
            id: 37854,
            name: "One Piece",
            overview: "Years ago, the fearsome Pirate King, Gol D. Roger was executed leaving a huge pile of treasure and the famous \"One Piece\" behind.",
            posterPath: URL(string: "/cMD9Ygz11zjJzAovURpO75Qg7rT.jpg"),
            backdropPath: URL(string: "/oVfucXvhutTpYExG9k06NJqnpT9.jpg")
        ),
        TVSeriesPreview(
            id: 103_540,
            name: "Percy Jackson and the Olympians",
            overview: "Percy Jackson is on a dangerous quest. Outrunning monsters and outwitting gods.",
            posterPath: URL(string: "/40eFcTzZier3DWLqldsP5VHxeoD.jpg"),
            backdropPath: URL(string: "/sAxx25ijwYQ8xsT56wu2IzvIRss.jpg")
        ),
        TVSeriesPreview(
            id: 79744,
            name: "The Rookie",
            overview: "Starting over isn't easy, especially for small-town guy John Nolan.",
            posterPath: URL(string: "/70kTz0OmjjZe7zHvIDrq2iKW7PJ.jpg"),
            backdropPath: URL(string: "/6iNWfGVCEfASDdlNb05TP5nG0ll.jpg")
        )
    ]

    static let trendingPeople: [PersonPreview] = [
        PersonPreview(
            id: 2963,
            name: "Nicolas Cage",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: URL(string: "/y1RtezurZYveYkVNRht7CwEgSYY.jpg")
        ),
        PersonPreview(
            id: 500,
            name: "Tom Cruise",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: URL(string: "/3mShHjSQR7NXOVbdTu5rT2Qd0MN.jpg")
        ),
        PersonPreview(
            id: 115_440,
            name: "Sydney Sweeney",
            knownForDepartment: "Acting",
            gender: .female,
            profilePath: URL(string: "/qYiaSl0Eb7G3VaxOg8PxExCFwon.jpg")
        ),
        PersonPreview(
            id: 3416,
            name: "Demi Moore",
            knownForDepartment: "Acting",
            gender: .female,
            profilePath: URL(string: "/wApParZYBDi4yxekjfxjKEifJYh.jpg")
        ),
        PersonPreview(
            id: 287,
            name: "Brad Pitt",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: URL(string: "/ajNaPmXVVMJFg9GWmu6MJzTaXdV.jpg")
        ),
        PersonPreview(
            id: 54693,
            name: "Emma Stone",
            knownForDepartment: "Acting",
            gender: .female,
            profilePath: URL(string: "/8NwSfyYWIIUE1cI9Xhz92b0w7WD.jpg")
        ),
        PersonPreview(
            id: 74568,
            name: "Chris Hemsworth",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: URL(string: "/piQGdoIQOF3C1EI5cbYZLAW1gfj.jpg")
        ),
        PersonPreview(
            id: 3,
            name: "Harrison Ford",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: URL(string: "/5M7oN3sznp99hWYQ9sX0xheswWX.jpg")
        )
    ]
    // swiftlint:enable line_length

}
