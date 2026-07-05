//
//  FetchTrendingTVSeriesErrorTests.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TrendingApplication
import TrendingDomain

@Suite("FetchTrendingTVSeriesError")
struct FetchTrendingTVSeriesErrorTests {

    @Test("maps repository unauthorised error to unauthorised")
    func mapsRepositoryUnauthorisedErrorToUnauthorised() {
        let error = FetchTrendingTVSeriesError(TrendingRepositoryError.unauthorised)

        #expect(isUnauthorised(error))
    }

    @Test("maps repository unknown error to unknown")
    func mapsRepositoryUnknownErrorToUnknown() {
        let error = FetchTrendingTVSeriesError(TrendingRepositoryError.unknown(NSError(domain: "test", code: 1)))

        #expect(isUnknown(error))
    }

    @Test("maps app configuration unauthorised error to unauthorised")
    func mapsAppConfigurationUnauthorisedErrorToUnauthorised() {
        let error = FetchTrendingTVSeriesError(AppConfigurationProviderError.unauthorised)

        #expect(isUnauthorised(error))
    }

    @Test("maps app configuration unknown error to unknown")
    func mapsAppConfigurationUnknownErrorToUnknown() {
        let error = FetchTrendingTVSeriesError(AppConfigurationProviderError.unknown())

        #expect(isUnknown(error))
    }

    @Test("maps unrecognised error to unknown")
    func mapsUnrecognisedErrorToUnknown() {
        let error = FetchTrendingTVSeriesError(UnrelatedTestError())

        #expect(isUnknown(error))
    }

}

extension FetchTrendingTVSeriesErrorTests {

    private func isUnauthorised(_ error: FetchTrendingTVSeriesError) -> Bool {
        if case .unauthorised = error {
            return true
        }
        return false
    }

    private func isUnknown(_ error: FetchTrendingTVSeriesError) -> Bool {
        if case .unknown = error {
            return true
        }
        return false
    }

}

private struct UnrelatedTestError: Error {}
