//
//  FetchTrendingPeopleErrorTests.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TrendingApplication
import TrendingDomain

@Suite("FetchTrendingPeopleError")
struct FetchTrendingPeopleErrorTests {

    @Test("maps repository unauthorised error to unauthorised")
    func mapsRepositoryUnauthorisedErrorToUnauthorised() {
        let error = FetchTrendingPeopleError(TrendingRepositoryError.unauthorised)

        #expect(isUnauthorised(error))
    }

    @Test("maps repository unknown error to unknown")
    func mapsRepositoryUnknownErrorToUnknown() {
        let error = FetchTrendingPeopleError(TrendingRepositoryError.unknown(NSError(domain: "test", code: 1)))

        #expect(isUnknown(error))
    }

    @Test("maps app configuration unauthorised error to unauthorised")
    func mapsAppConfigurationUnauthorisedErrorToUnauthorised() {
        let error = FetchTrendingPeopleError(AppConfigurationProviderError.unauthorised)

        #expect(isUnauthorised(error))
    }

    @Test("maps app configuration unknown error to unknown")
    func mapsAppConfigurationUnknownErrorToUnknown() {
        let error = FetchTrendingPeopleError(AppConfigurationProviderError.unknown())

        #expect(isUnknown(error))
    }

    @Test("maps unrecognised error to unknown")
    func mapsUnrecognisedErrorToUnknown() {
        let error = FetchTrendingPeopleError(UnrelatedTestError())

        #expect(isUnknown(error))
    }

}

extension FetchTrendingPeopleErrorTests {

    private func isUnauthorised(_ error: FetchTrendingPeopleError) -> Bool {
        if case .unauthorised = error {
            return true
        }
        return false
    }

    private func isUnknown(_ error: FetchTrendingPeopleError) -> Bool {
        if case .unknown = error {
            return true
        }
        return false
    }

}

private struct UnrelatedTestError: Error {}
