//
//  MockFetchTVSeriesDetailsUseCase.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

struct MockFetchTVSeriesDetailsUseCase: FetchTVSeriesDetailsUseCase {

    let tvSeriesDetails: TVSeriesApplication.TVSeriesDetails?

    func execute(id: Int) async throws(FetchTVSeriesDetailsError) -> TVSeriesApplication.TVSeriesDetails {
        guard let tvSeriesDetails else {
            throw .notFound
        }
        return tvSeriesDetails
    }

}
