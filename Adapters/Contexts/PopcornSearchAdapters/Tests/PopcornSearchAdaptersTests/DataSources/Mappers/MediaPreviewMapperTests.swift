//
//  MediaPreviewMapperTests.swift
//  PopcornSearchAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
@testable import PopcornSearchAdapters
import SearchDomain
import Testing
import TMDb

@Suite("MediaPreviewMapper Tests")
struct MediaPreviewMapperTests {

    @Test("map converts TMDb Media movie to MediaPreview movie")
    func mapConvertsTMDbMediaMovieToMediaPreviewMovie() throws {
        let posterPath = try #require(URL(string: "https://tmdb.example/poster.jpg"))
        let movieListItem = MovieListItem(
            id: 123,
            title: "Test Movie",
            originalTitle: "Test Movie Original",
            originalLanguage: "en",
            overview: "A test movie overview",
            genreIDs: [28],
            posterPath: posterPath
        )
        let media: Media = .movie(movieListItem)

        let mapper = MediaPreviewMapper()
        let result = mapper.map(media)

        let mediaPreview = try #require(result)
        guard case .movie(let moviePreview) = mediaPreview else {
            Issue.record("Expected movie case")
            return
        }

        #expect(moviePreview.id == 123)
        #expect(moviePreview.title == "Test Movie")
        #expect(moviePreview.overview == "A test movie overview")
        #expect(moviePreview.posterPath == posterPath)
    }

    @Test("map converts TMDb Media tvSeries to MediaPreview tvSeries")
    func mapConvertsTMDbMediaTVSeriesToMediaPreviewTVSeries() throws {
        let posterPath = try #require(URL(string: "https://tmdb.example/poster.jpg"))
        let tvSeriesListItem = TVSeriesListItem(
            id: 456,
            name: "Test TV Series",
            originalName: "Test TV Series Original",
            originalLanguage: "en",
            overview: "A test TV series overview",
            genreIDs: [18],
            originCountries: ["US"],
            posterPath: posterPath
        )
        let media: Media = .tvSeries(tvSeriesListItem)

        let mapper = MediaPreviewMapper()
        let result = mapper.map(media)

        let mediaPreview = try #require(result)
        guard case .tvSeries(let tvSeriesPreview) = mediaPreview else {
            Issue.record("Expected tvSeries case")
            return
        }

        #expect(tvSeriesPreview.id == 456)
        #expect(tvSeriesPreview.name == "Test TV Series")
        #expect(tvSeriesPreview.overview == "A test TV series overview")
        #expect(tvSeriesPreview.posterPath == posterPath)
    }

    @Test("map converts TMDb Media person to MediaPreview person")
    func mapConvertsTMDbMediaPersonToMediaPreviewPerson() throws {
        let profilePath = try #require(URL(string: "https://tmdb.example/profile.jpg"))
        let personListItem = PersonListItem(
            id: 789,
            name: "Test Person",
            originalName: "Test Person Original",
            knownForDepartment: "Acting",
            gender: .female,
            profilePath: profilePath
        )
        let media: Media = .person(personListItem)

        let mapper = MediaPreviewMapper()
        let result = mapper.map(media)

        let mediaPreview = try #require(result)
        guard case .person(let personPreview) = mediaPreview else {
            Issue.record("Expected person case")
            return
        }

        #expect(personPreview.id == 789)
        #expect(personPreview.name == "Test Person")
        #expect(personPreview.knownForDepartment == "Acting")
        #expect(personPreview.gender == .female)
        #expect(personPreview.profilePath == profilePath)
    }

    @Test("map returns nil for TMDb Media collection")
    func mapReturnsNilForTMDbMediaCollection() {
        let collectionListItem = CollectionListItem(
            id: 999,
            title: "Test Collection",
            originalTitle: "Test Collection Original",
            originalLanguage: "en",
            overview: "A test collection overview",
            posterPath: nil,
            backdropPath: nil
        )
        let media: Media = .collection(collectionListItem)

        let mapper = MediaPreviewMapper()
        let result = mapper.map(media)

        #expect(result == nil)
    }

    @Test("map preserves media id through MediaPreview id property for movie")
    func mapPreservesMediaIdThroughMediaPreviewIdPropertyForMovie() throws {
        let movieListItem = MovieListItem(
            id: 42,
            title: "ID Test Movie",
            originalTitle: "ID Test Movie",
            originalLanguage: "en",
            overview: "Testing ID",
            genreIDs: []
        )
        let media: Media = .movie(movieListItem)

        let mapper = MediaPreviewMapper()
        let result = try #require(mapper.map(media))

        #expect(result.id == 42)
    }

    @Test("map preserves media id through MediaPreview id property for tvSeries")
    func mapPreservesMediaIdThroughMediaPreviewIdPropertyForTVSeries() throws {
        let tvSeriesListItem = TVSeriesListItem(
            id: 84,
            name: "ID Test TV Series",
            originalName: "ID Test TV Series",
            originalLanguage: "en",
            overview: "Testing ID",
            genreIDs: [],
            originCountries: []
        )
        let media: Media = .tvSeries(tvSeriesListItem)

        let mapper = MediaPreviewMapper()
        let result = try #require(mapper.map(media))

        #expect(result.id == 84)
    }

    @Test("map preserves media id through MediaPreview id property for person")
    func mapPreservesMediaIdThroughMediaPreviewIdPropertyForPerson() throws {
        let personListItem = PersonListItem(
            id: 168,
            name: "ID Test Person",
            originalName: "ID Test Person",
            gender: .unknown
        )
        let media: Media = .person(personListItem)

        let mapper = MediaPreviewMapper()
        let result = try #require(mapper.map(media))

        #expect(result.id == 168)
    }

}
