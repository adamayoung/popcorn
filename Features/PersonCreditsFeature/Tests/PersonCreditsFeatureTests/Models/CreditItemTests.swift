//
//  CreditItemTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PersonCreditsFeature
import Testing

@Suite("CreditItem Tests")
struct CreditItemTests {

    @Test("a movie and a TV series sharing a TMDb id have distinct identities")
    func movieAndTVSeriesSharingIDHaveDistinctIdentities() {
        let movie = CreditItem.mock(mediaID: 7, mediaType: .movie)
        let tvSeries = CreditItem.mock(mediaID: 7, mediaType: .tvSeries)

        #expect(movie.id != tvSeries.id)
    }

    @Test("identity is stable for the same media type and id")
    func identityIsStableForSameMediaTypeAndID() {
        #expect(CreditItem.mock(mediaID: 7, mediaType: .movie).id
            == CreditItem.mock(mediaID: 7, mediaType: .movie).id)
    }

}
