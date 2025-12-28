//
//  TVSeriesProvider.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain
import TVSeriesApplication

///
/// An adapter that provides TV series data for the intelligence domain.
///
/// Bridges the TV series application layer to the intelligence domain by wrapping
/// the ``FetchTVSeriesDetailsUseCase``.
///
final class TVSeriesProviderAdapter: TVSeriesProviding {

    private let fetchTVSeriesDetailsUseCase: any FetchTVSeriesDetailsUseCase

    ///
    /// Creates a TV series provider adapter.
    ///
    /// - Parameter fetchTVSeriesDetailsUseCase: The use case for fetching TV series details.
    ///
    init(
        fetchTVSeriesDetailsUseCase: some FetchTVSeriesDetailsUseCase
    ) {
        self.fetchTVSeriesDetailsUseCase = fetchTVSeriesDetailsUseCase
    }

    ///
    /// Fetches TV series data by identifier.
    ///
    /// - Parameter id: The identifier of the TV series.
    /// - Returns: A TV series suitable for the intelligence domain.
    /// - Throws: ``TVSeriesProviderError`` if the TV series cannot be fetched.
    ///
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
