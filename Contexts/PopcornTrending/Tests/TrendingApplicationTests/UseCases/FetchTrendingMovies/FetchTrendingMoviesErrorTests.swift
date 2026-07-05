//
//  FetchTrendingMoviesErrorTests.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TrendingApplication
import TrendingDomain

@Suite("FetchTrendingMoviesError")
struct FetchTrendingMoviesErrorTests {

    @Test("maps repository unauthorised error to unauthorised")
    func mapsRepositoryUnauthorisedErrorToUnauthorised() {
        let error = FetchTrendingMoviesError(TrendingRepositoryError.unauthorised)

        #expect(isUnauthorised(error))
    }

    @Test("maps repository unknown error to unknown")
    func mapsRepositoryUnknownErrorToUnknown() {
        let error = FetchTrendingMoviesError(TrendingRepositoryError.unknown(NSError(domain: "test", code: 1)))

        #expect(isUnknown(error))
    }

    @Test("maps app configuration unauthorised error to unauthorised")
    func mapsAppConfigurationUnauthorisedErrorToUnauthorised() {
        let error = FetchTrendingMoviesError(AppConfigurationProviderError.unauthorised)

        #expect(isUnauthorised(error))
    }

    @Test("maps app configuration unknown error to unknown")
    func mapsAppConfigurationUnknownErrorToUnknown() {
        let error = FetchTrendingMoviesError(AppConfigurationProviderError.unknown())

        #expect(isUnknown(error))
    }

    @Test("maps unrecognised error to unknown")
    func mapsUnrecognisedErrorToUnknown() {
        let error = FetchTrendingMoviesError(UnrelatedTestError())

        #expect(isUnknown(error))
    }

}

extension FetchTrendingMoviesErrorTests {

    private func isUnauthorised(_ error: FetchTrendingMoviesError) -> Bool {
        if case .unauthorised = error {
            return true
        }
        return false
    }

    private func isUnknown(_ error: FetchTrendingMoviesError) -> Bool {
        if case .unknown = error {
            return true
        }
        return false
    }

}

private struct UnrelatedTestError: Error {}
