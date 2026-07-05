//
//  MoviePreviewDetailsMapperTests.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import CoreDomainTestHelpers
import Foundation
import Testing
@testable import TrendingApplication
import TrendingDomain

@Suite("MoviePreviewDetailsMapper")
struct MoviePreviewDetailsMapperTests {

    let mapper = MoviePreviewDetailsMapper()
    let imagesConfiguration = ImagesConfiguration.mock()

    @Test("maps core properties from movie preview")
    func mapsCoreProperties() {
        let moviePreview = MoviePreview.mock(id: 550, title: "Fight Club", overview: "An insomniac.")

        let result = mapper.map(moviePreview, imagesConfiguration: imagesConfiguration)

        #expect(result.id == 550)
        #expect(result.title == "Fight Club")
        #expect(result.overview == "An insomniac.")
    }

    @Test("maps poster URL set from poster path")
    func mapsPosterURLSet() {
        let moviePreview = MoviePreview.mock(posterPath: URL(string: "/poster.jpg"))

        let result = mapper.map(moviePreview, imagesConfiguration: imagesConfiguration)

        #expect(result.posterURLSet == imagesConfiguration.posterURLSet(for: moviePreview.posterPath))
    }

    @Test("currently sizes the backdrop with the poster handler (known quirk)")
    func mapsBackdropURLSetUsingPosterHandler() {
        // Characterization of current (wrong) behaviour: the mapper sizes the
        // backdrop via `posterURLSet(for:)` instead of `backdropURLSet(for:)`, so
        // backdrops are fetched at poster width buckets. Do NOT re-point this
        // assertion to `backdropURLSet(for:)` without fixing the production mapper.
        let moviePreview = MoviePreview.mock(backdropPath: URL(string: "/backdrop.jpg"))

        let result = mapper.map(moviePreview, imagesConfiguration: imagesConfiguration)

        #expect(result.backdropURLSet == imagesConfiguration.posterURLSet(for: moviePreview.backdropPath))
    }

    @Test("returns nil poster and backdrop URL sets when paths are nil")
    func returnsNilURLSetsWhenPathsAreNil() {
        let moviePreview = MoviePreview.mock(posterPath: nil, backdropPath: nil)

        let result = mapper.map(moviePreview, imagesConfiguration: imagesConfiguration)

        #expect(result.posterURLSet == nil)
        #expect(result.backdropURLSet == nil)
    }

    @Test("always maps logo URL set to nil")
    func alwaysMapsLogoURLSetToNil() {
        let moviePreview = MoviePreview.mock()

        let result = mapper.map(moviePreview, imagesConfiguration: imagesConfiguration)

        #expect(result.logoURLSet == nil)
    }

    @Test("maps theme color when provided")
    func mapsThemeColorWhenProvided() {
        let moviePreview = MoviePreview.mock()
        let themeColor = ThemeColor.mock()

        let result = mapper.map(moviePreview, imagesConfiguration: imagesConfiguration, themeColor: themeColor)

        #expect(result.themeColor == themeColor)
    }

    @Test("defaults theme color to nil when not provided")
    func defaultsThemeColorToNilWhenNotProvided() {
        let moviePreview = MoviePreview.mock()

        let result = mapper.map(moviePreview, imagesConfiguration: imagesConfiguration)

        #expect(result.themeColor == nil)
    }

}
