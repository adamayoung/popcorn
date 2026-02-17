//
//  TVSeries+Mocks.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

extension TVSeries {

    static func mock(
        id: Int = 1396,
        name: String = "Breaking Bad",
        overview: String = """
        Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis \
        of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire \
        to secure his family's financial future at any cost as he enters the dangerous world of drugs and crime.
        """,
        firstAirDate: Date = Date(timeIntervalSince1970: 1_200_528_000),
        posterPath: URL? = URL(string: "/poster.jpg"),
        backdropPath: URL? = URL(string: "/backdrop.jpg")
    ) -> TVSeries {
        TVSeries(
            id: id,
            name: name,
            overview: overview,
            firstAirDate: firstAirDate,
            posterPath: posterPath,
            backdropPath: backdropPath
        )
    }

}
