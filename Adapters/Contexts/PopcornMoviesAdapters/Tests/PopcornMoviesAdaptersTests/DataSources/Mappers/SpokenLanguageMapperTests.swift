//
//  SpokenLanguageMapperTests.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
@testable import PopcornMoviesAdapters
import Testing
import TMDb

@Suite("SpokenLanguageMapper Tests")
struct SpokenLanguageMapperTests {

    private let mapper = SpokenLanguageMapper()

    @Test("Maps all properties from TMDb to domain")
    func mapsAllProperties() {
        let tmdbLanguage = TMDb.SpokenLanguage(languageCode: "en", name: "English")

        let result = mapper.map(tmdbLanguage)

        #expect(result.languageCode == "en")
        #expect(result.name == "English")
    }

    @Test("Maps multiple languages correctly")
    func mapsMultipleLanguages() {
        let tmdbLanguages = [
            TMDb.SpokenLanguage(languageCode: "en", name: "English"),
            TMDb.SpokenLanguage(languageCode: "fr", name: "French")
        ]

        let results = tmdbLanguages.map(mapper.map)

        #expect(results.count == 2)
        #expect(results[0].languageCode == "en")
        #expect(results[0].name == "English")
        #expect(results[1].languageCode == "fr")
        #expect(results[1].name == "French")
    }

}
