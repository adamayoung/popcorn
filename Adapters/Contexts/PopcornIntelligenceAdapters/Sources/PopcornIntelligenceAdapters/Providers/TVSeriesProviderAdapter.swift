//
//  TVSeriesProviderAdapter.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain
import TVSeriesApplication

final class TVSeriesProviderAdapter: TVSeriesProviding {

    private let fetchTVSeriesDetailsUseCase: any FetchTVSeriesDetailsUseCase

    init(
        fetchTVSeriesDetailsUseCase: some FetchTVSeriesDetailsUseCase
    ) {
        self.fetchTVSeriesDetailsUseCase = fetchTVSeriesDetailsUseCase
    }

    func tvSeries(withID id: Int) async throws(TVSeriesProviderError) -> IntelligenceDomain.TVSeries {
        let tvSeriesDetails: TVSeriesDetails
        do {
            tvSeriesDetails = try await fetchTVSeriesDetailsUseCase.execute(id: id)
        } catch let error {
            throw TVSeriesProviderError(error)
        }

        let mapper = TVSeriesMapper()
        return mapper.map(tvSeriesDetails)
    }

}

extension TVSeriesProviderError {

    init(_ error: FetchTVSeriesDetailsError) {
        switch error {
        case .notFound: self = .notFound
        case .unauthorised: self = .unauthorised
        case .unknown(let error): self = .unknown(error)
        }
    }

}
