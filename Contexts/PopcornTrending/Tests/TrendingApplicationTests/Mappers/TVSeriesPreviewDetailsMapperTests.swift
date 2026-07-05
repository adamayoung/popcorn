//
//  TVSeriesPreviewDetailsMapperTests.swift
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

@Suite("TVSeriesPreviewDetailsMapper")
struct TVSeriesPreviewDetailsMapperTests {

    let mapper = TVSeriesPreviewDetailsMapper()
    let imagesConfiguration = ImagesConfiguration.mock()

    @Test("maps core properties from tv series preview")
    func mapsCoreProperties() {
        let tvSeriesPreview = TVSeriesPreview.mock(id: 1399, name: "Game of Thrones", overview: "Seven noble families.")

        let result = mapper.map(tvSeriesPreview, imagesConfiguration: imagesConfiguration)

        #expect(result.id == 1399)
        #expect(result.name == "Game of Thrones")
        #expect(result.overview == "Seven noble families.")
    }

    @Test("maps poster URL set from poster path")
    func mapsPosterURLSet() {
        let tvSeriesPreview = TVSeriesPreview.mock(posterPath: URL(string: "/poster.jpg"))

        let result = mapper.map(tvSeriesPreview, imagesConfiguration: imagesConfiguration)

        #expect(result.posterURLSet == imagesConfiguration.posterURLSet(for: tvSeriesPreview.posterPath))
    }

    @Test("maps backdrop URL set from backdrop path")
    func mapsBackdropURLSet() {
        let tvSeriesPreview = TVSeriesPreview.mock(backdropPath: URL(string: "/backdrop.jpg"))

        let result = mapper.map(tvSeriesPreview, imagesConfiguration: imagesConfiguration)

        #expect(result.backdropURLSet == imagesConfiguration.posterURLSet(for: tvSeriesPreview.backdropPath))
    }

    @Test("returns nil poster and backdrop URL sets when paths are nil")
    func returnsNilURLSetsWhenPathsAreNil() {
        let tvSeriesPreview = TVSeriesPreview.mock(posterPath: nil, backdropPath: nil)

        let result = mapper.map(tvSeriesPreview, imagesConfiguration: imagesConfiguration)

        #expect(result.posterURLSet == nil)
        #expect(result.backdropURLSet == nil)
    }

    @Test("always maps logo URL set to nil")
    func alwaysMapsLogoURLSetToNil() {
        let tvSeriesPreview = TVSeriesPreview.mock()

        let result = mapper.map(tvSeriesPreview, imagesConfiguration: imagesConfiguration)

        #expect(result.logoURLSet == nil)
    }

    @Test("maps theme color when provided")
    func mapsThemeColorWhenProvided() {
        let tvSeriesPreview = TVSeriesPreview.mock()
        let themeColor = ThemeColor.mock()

        let result = mapper.map(tvSeriesPreview, imagesConfiguration: imagesConfiguration, themeColor: themeColor)

        #expect(result.themeColor == themeColor)
    }

    @Test("defaults theme color to nil when not provided")
    func defaultsThemeColorToNilWhenNotProvided() {
        let tvSeriesPreview = TVSeriesPreview.mock()

        let result = mapper.map(tvSeriesPreview, imagesConfiguration: imagesConfiguration)

        #expect(result.themeColor == nil)
    }

}
