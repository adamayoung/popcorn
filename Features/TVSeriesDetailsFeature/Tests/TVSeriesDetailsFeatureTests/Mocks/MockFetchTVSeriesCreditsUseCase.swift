//
//  MockFetchTVSeriesCreditsUseCase.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

struct MockFetchTVSeriesCreditsUseCase: FetchTVSeriesCreditsUseCase {

    let credits: TVSeriesApplication.CreditsDetails?

    func execute(tvSeriesID: Int) async throws(FetchTVSeriesCreditsError) -> TVSeriesApplication.CreditsDetails {
        guard let credits else {
            throw .notFound
        }
        return credits
    }

}
