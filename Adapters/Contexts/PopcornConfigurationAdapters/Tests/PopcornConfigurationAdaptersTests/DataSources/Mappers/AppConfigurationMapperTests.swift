//
//  AppConfigurationMapperTests.swift
//  PopcornConfigurationAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornConfigurationAdapters
import Testing
import TMDb

@Suite("AppConfigurationMapper Tests")
struct AppConfigurationMapperTests {

    private let mapper = AppConfigurationMapper()

    @Test("Maps TMDb APIConfiguration to AppConfiguration")
    func mapsAPIConfigurationToAppConfiguration() throws {
        let baseURL = try #require(URL(string: "http://image.tmdb.org/t/p/"))
        let secureBaseURL = try #require(URL(string: "https://image.tmdb.org/t/p/"))
        let tmdbImagesConfiguration = TMDb.ImagesConfiguration(
            baseURL: baseURL,
            secureBaseURL: secureBaseURL,
            backdropSizes: ["w300", "w780", "w1280", "original"],
            logoSizes: ["w45", "w92", "w154", "w185", "w300", "w500", "original"],
            posterSizes: ["w92", "w154", "w185", "w342", "w500", "w780", "original"],
            profileSizes: ["w45", "w185", "h632", "original"],
            stillSizes: ["w92", "w185", "w300", "original"]
        )
        let tmdbAPIConfiguration = TMDb.APIConfiguration(
            images: tmdbImagesConfiguration,
            changeKeys: ["adult", "air_date", "title"]
        )

        let result = mapper.map(tmdbAPIConfiguration)
        let posterPath = try #require(URL(string: "/poster.jpg"))

        #expect(result.images.posterURLSet(for: posterPath) != nil)
    }

    @Test("Maps TMDb ImagesConfiguration posterURL handler correctly")
    func mapsImagesConfigurationPosterURLHandler() throws {
        let baseURL = try #require(URL(string: "http://image.tmdb.org/t/p/"))
        let secureBaseURL = try #require(URL(string: "https://image.tmdb.org/t/p/"))
        let tmdbImagesConfiguration = TMDb.ImagesConfiguration(
            baseURL: baseURL,
            secureBaseURL: secureBaseURL,
            backdropSizes: ["w300", "w780", "w1280", "original"],
            logoSizes: ["w45", "w92", "w154", "w185", "w300", "w500", "original"],
            posterSizes: ["w92", "w154", "w185", "w342", "w500", "w780", "original"],
            profileSizes: ["w45", "w185", "h632", "original"],
            stillSizes: ["w92", "w185", "w300", "original"]
        )

        let result = mapper.map(tmdbImagesConfiguration)
        let posterPath = try #require(URL(string: "/poster123.jpg"))

        let posterURLSet = result.posterURLSet(for: posterPath)

        #expect(posterURLSet != nil)
        #expect(posterURLSet?.path == posterPath)
    }

    @Test("Maps TMDb ImagesConfiguration backdropURL handler correctly")
    func mapsImagesConfigurationBackdropURLHandler() throws {
        let baseURL = try #require(URL(string: "http://image.tmdb.org/t/p/"))
        let secureBaseURL = try #require(URL(string: "https://image.tmdb.org/t/p/"))
        let tmdbImagesConfiguration = TMDb.ImagesConfiguration(
            baseURL: baseURL,
            secureBaseURL: secureBaseURL,
            backdropSizes: ["w300", "w780", "w1280", "original"],
            logoSizes: ["w45", "w92", "w154", "w185", "w300", "w500", "original"],
            posterSizes: ["w92", "w154", "w185", "w342", "w500", "w780", "original"],
            profileSizes: ["w45", "w185", "h632", "original"],
            stillSizes: ["w92", "w185", "w300", "original"]
        )

        let result = mapper.map(tmdbImagesConfiguration)
        let backdropPath = try #require(URL(string: "/backdrop123.jpg"))

        let backdropURLSet = result.backdropURLSet(for: backdropPath)

        #expect(backdropURLSet != nil)
        #expect(backdropURLSet?.path == backdropPath)
    }

    @Test("Maps TMDb ImagesConfiguration logoURL handler correctly")
    func mapsImagesConfigurationLogoURLHandler() throws {
        let baseURL = try #require(URL(string: "http://image.tmdb.org/t/p/"))
        let secureBaseURL = try #require(URL(string: "https://image.tmdb.org/t/p/"))
        let tmdbImagesConfiguration = TMDb.ImagesConfiguration(
            baseURL: baseURL,
            secureBaseURL: secureBaseURL,
            backdropSizes: ["w300", "w780", "w1280", "original"],
            logoSizes: ["w45", "w92", "w154", "w185", "w300", "w500", "original"],
            posterSizes: ["w92", "w154", "w185", "w342", "w500", "w780", "original"],
            profileSizes: ["w45", "w185", "h632", "original"],
            stillSizes: ["w92", "w185", "w300", "original"]
        )

        let result = mapper.map(tmdbImagesConfiguration)
        let logoPath = try #require(URL(string: "/logo123.png"))

        let logoURLSet = result.logoURLSet(for: logoPath)

        #expect(logoURLSet != nil)
        #expect(logoURLSet?.path == logoPath)
    }

    @Test("Maps TMDb ImagesConfiguration profileURL handler correctly")
    func mapsImagesConfigurationProfileURLHandler() throws {
        let baseURL = try #require(URL(string: "http://image.tmdb.org/t/p/"))
        let secureBaseURL = try #require(URL(string: "https://image.tmdb.org/t/p/"))
        let tmdbImagesConfiguration = TMDb.ImagesConfiguration(
            baseURL: baseURL,
            secureBaseURL: secureBaseURL,
            backdropSizes: ["w300", "w780", "w1280", "original"],
            logoSizes: ["w45", "w92", "w154", "w185", "w300", "w500", "original"],
            posterSizes: ["w92", "w154", "w185", "w342", "w500", "w780", "original"],
            profileSizes: ["w45", "w185", "h632", "original"],
            stillSizes: ["w92", "w185", "w300", "original"]
        )

        let result = mapper.map(tmdbImagesConfiguration)
        let profilePath = try #require(URL(string: "/profile123.jpg"))

        let profileURLSet = result.profileURLSet(for: profilePath)

        #expect(profileURLSet != nil)
        #expect(profileURLSet?.path == profilePath)
    }

    @Test("Maps TMDb ImagesConfiguration stillURL handler correctly")
    func mapsImagesConfigurationStillURLHandler() throws {
        let baseURL = try #require(URL(string: "http://image.tmdb.org/t/p/"))
        let secureBaseURL = try #require(URL(string: "https://image.tmdb.org/t/p/"))
        let tmdbImagesConfiguration = TMDb.ImagesConfiguration(
            baseURL: baseURL,
            secureBaseURL: secureBaseURL,
            backdropSizes: ["w300", "w780", "w1280", "original"],
            logoSizes: ["w45", "w92", "w154", "w185", "w300", "w500", "original"],
            posterSizes: ["w92", "w154", "w185", "w342", "w500", "w780", "original"],
            profileSizes: ["w45", "w185", "h632", "original"],
            stillSizes: ["w92", "w185", "w300", "original"]
        )

        let result = mapper.map(tmdbImagesConfiguration)
        let stillPath = try #require(URL(string: "/still123.jpg"))

        let stillURLSet = result.stillURLSet(for: stillPath)

        #expect(stillURLSet != nil)
        #expect(stillURLSet?.path == stillPath)
    }

    @Test("Returns nil URL set when path is nil")
    func returnsNilURLSetWhenPathIsNil() throws {
        let baseURL = try #require(URL(string: "http://image.tmdb.org/t/p/"))
        let secureBaseURL = try #require(URL(string: "https://image.tmdb.org/t/p/"))
        let tmdbImagesConfiguration = TMDb.ImagesConfiguration(
            baseURL: baseURL,
            secureBaseURL: secureBaseURL,
            backdropSizes: ["w300", "original"],
            logoSizes: ["w45", "original"],
            posterSizes: ["w92", "original"],
            profileSizes: ["w45", "original"],
            stillSizes: ["w92", "original"]
        )

        let result = mapper.map(tmdbImagesConfiguration)

        #expect(result.posterURLSet(for: nil) == nil)
        #expect(result.backdropURLSet(for: nil) == nil)
        #expect(result.logoURLSet(for: nil) == nil)
        #expect(result.profileURLSet(for: nil) == nil)
        #expect(result.stillURLSet(for: nil) == nil)
    }

}
