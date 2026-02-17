//
//  MediaPreview+Mocks.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import SearchDomain

extension MediaPreview {

    static var movieMock: MediaPreview {
        .movie(MoviePreview.mock())
    }

    static var tvSeriesMock: MediaPreview {
        .tvSeries(TVSeriesPreview.mock())
    }

    static var personMock: MediaPreview {
        .person(PersonPreview.mock())
    }

    static var mocks: [MediaPreview] {
        [.movieMock, .tvSeriesMock, .personMock]
    }

}

extension MoviePreview {

    static func mock(
        id: Int = 1,
        title: String = "Inception",
        overview: String = "A mind-bending thriller",
        posterPath: URL? = URL(string: "/poster.jpg"),
        backdropPath: URL? = URL(string: "/backdrop.jpg")
    ) -> MoviePreview {
        MoviePreview(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath
        )
    }

}

extension TVSeriesPreview {

    static func mock(
        id: Int = 2,
        name: String = "Breaking Bad",
        overview: String = "A chemistry teacher turned drug lord",
        posterPath: URL? = URL(string: "/poster.jpg"),
        backdropPath: URL? = URL(string: "/backdrop.jpg")
    ) -> TVSeriesPreview {
        TVSeriesPreview(
            id: id,
            name: name,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath
        )
    }

}

extension PersonPreview {

    static func mock(
        id: Int = 3,
        name: String = "Tom Hanks",
        knownForDepartment: String = "Acting",
        gender: Gender = .male,
        profilePath: URL? = URL(string: "/profile.jpg")
    ) -> PersonPreview {
        PersonPreview(
            id: id,
            name: name,
            knownForDepartment: knownForDepartment,
            gender: gender,
            profilePath: profilePath
        )
    }

}

extension MovieSearchHistoryEntry {

    static func mock(
        id: Int = 1,
        timestamp: Date = Date(timeIntervalSince1970: 1000)
    ) -> MovieSearchHistoryEntry {
        MovieSearchHistoryEntry(id: id, timestamp: timestamp)
    }

}

extension TVSeriesSearchHistoryEntry {

    static func mock(
        id: Int = 2,
        timestamp: Date = Date(timeIntervalSince1970: 2000)
    ) -> TVSeriesSearchHistoryEntry {
        TVSeriesSearchHistoryEntry(id: id, timestamp: timestamp)
    }

}

extension PersonSearchHistoryEntry {

    static func mock(
        id: Int = 3,
        timestamp: Date = Date(timeIntervalSince1970: 3000)
    ) -> PersonSearchHistoryEntry {
        PersonSearchHistoryEntry(id: id, timestamp: timestamp)
    }

}
