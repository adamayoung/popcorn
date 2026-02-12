//
//  MediaPreviewMapperTests.swift
//  MediaSearchFeature
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
@testable import MediaSearchFeature
import SearchApplication
import Testing

@Suite("MediaPreviewMapper Tests")
struct MediaPreviewMapperTests {

    private let mapper = MediaPreviewMapper()

    @Test("Maps movie MediaPreviewDetails to MediaPreview.movie")
    func mapsMovieMediaPreviewDetails() throws {
        let posterURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )

        let movieDetails = SearchApplication.MoviePreviewDetails(
            id: 798_645,
            title: "The Running Man",
            overview: "A thrilling action movie.",
            posterURLSet: posterURLSet
        )
        let details = MediaPreviewDetails.movie(movieDetails)

        let result = mapper.map(details)

        if case .movie(let moviePreview) = result {
            #expect(moviePreview.id == 798_645)
            #expect(moviePreview.title == "The Running Man")
            #expect(moviePreview.posterURL == URL(string: "https://example.com/thumbnail.jpg"))
        } else {
            Issue.record("Expected movie case")
        }
    }

    @Test("Maps tvSeries MediaPreviewDetails to MediaPreview.tvSeries")
    func mapsTVSeriesMediaPreviewDetails() throws {
        let posterURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )

        let tvSeriesDetails = SearchApplication.TVSeriesPreviewDetails(
            id: 1399,
            name: "Game of Thrones",
            overview: "A fantasy epic.",
            posterURLSet: posterURLSet
        )
        let details = MediaPreviewDetails.tvSeries(tvSeriesDetails)

        let result = mapper.map(details)

        if case .tvSeries(let tvSeriesPreview) = result {
            #expect(tvSeriesPreview.id == 1399)
            #expect(tvSeriesPreview.name == "Game of Thrones")
            #expect(tvSeriesPreview.posterURL == URL(string: "https://example.com/thumbnail.jpg"))
        } else {
            Issue.record("Expected tvSeries case")
        }
    }

    @Test("Maps person MediaPreviewDetails to MediaPreview.person")
    func mapsPersonMediaPreviewDetails() throws {
        let profileURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )

        let personDetails = SearchApplication.PersonPreviewDetails(
            id: 83271,
            name: "Glen Powell",
            knownForDepartment: "Acting",
            gender: .male,
            profileURLSet: profileURLSet
        )
        let details = MediaPreviewDetails.person(personDetails)

        let result = mapper.map(details)

        if case .person(let personPreview) = result {
            #expect(personPreview.id == 83271)
            #expect(personPreview.name == "Glen Powell")
            #expect(personPreview.profileURL == URL(string: "https://example.com/thumbnail.jpg"))
        } else {
            Issue.record("Expected person case")
        }
    }

    @Test("Maps multiple media previews correctly")
    func mapsMultipleMediaPreviews() {
        let movieDetails = SearchApplication.MoviePreviewDetails(id: 1, title: "Movie", overview: "")
        let tvSeriesDetails = SearchApplication.TVSeriesPreviewDetails(id: 2, name: "Series", overview: "")
        let personDetails = SearchApplication.PersonPreviewDetails(id: 3, name: "Person", gender: .unknown)

        let details = [
            MediaPreviewDetails.movie(movieDetails),
            MediaPreviewDetails.tvSeries(tvSeriesDetails),
            MediaPreviewDetails.person(personDetails)
        ]

        let results = details.map(mapper.map)

        #expect(results.count == 3)

        if case .movie(let movie) = results[0] {
            #expect(movie.id == 1)
        } else {
            Issue.record("Expected movie case at index 0")
        }

        if case .tvSeries(let tvSeries) = results[1] {
            #expect(tvSeries.id == 2)
        } else {
            Issue.record("Expected tvSeries case at index 1")
        }

        if case .person(let person) = results[2] {
            #expect(person.id == 3)
        } else {
            Issue.record("Expected person case at index 2")
        }
    }

}
