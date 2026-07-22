//
//  FetchCreditsErrorTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PeopleApplication
@testable import PersonCreditsFeature
import Testing

@Suite("FetchCreditsError Tests")
struct FetchCreditsErrorTests {

    @Test("maps a notFound credits error to notFound")
    func mapsNotFoundToNotFound() {
        let error = FetchCreditsError(FetchPersonCreditsError.notFound)

        #expect(error.isNotFound)
    }

    @Test("maps an unauthorised credits error to unknown")
    func mapsUnauthorisedToUnknown() {
        let error = FetchCreditsError(FetchPersonCreditsError.unauthorised)

        #expect(error.isUnknown)
    }

    @Test("maps an unknown credits error to unknown")
    func mapsUnknownToUnknown() {
        let error = FetchCreditsError(FetchPersonCreditsError.unknown(nil))

        #expect(error.isUnknown)
    }

    @Test("maps an arbitrary error to unknown")
    func mapsArbitraryErrorToUnknown() {
        let error = FetchCreditsError(NSError(domain: "test", code: 1))

        #expect(error.isUnknown)
    }

    @Test("provides localized text for every case")
    func providesLocalizedTextForEveryCase() {
        let notFound = FetchCreditsError.notFound()
        let unknown = FetchCreditsError.unknown()

        #expect(notFound.errorDescription != nil)
        #expect(notFound.failureReason != nil)
        #expect(notFound.recoverySuggestion != nil)
        #expect(unknown.errorDescription != nil)
        #expect(unknown.failureReason != nil)
        #expect(unknown.recoverySuggestion != nil)
    }

}

private extension FetchCreditsError {

    var isNotFound: Bool {
        if case .notFound = self {
            true
        } else {
            false
        }
    }

    var isUnknown: Bool {
        if case .unknown = self {
            true
        } else {
            false
        }
    }

}
