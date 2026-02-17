//
//  TVSeriesLogoImageProviderAdapter.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import TrendingDomain
import TVSeriesApplication

final class TVSeriesLogoImageProviderAdapter: TVSeriesLogoImageProviding {

    private let fetchTVSeriesImageCollectionUseCase: any FetchTVSeriesImageCollectionUseCase

    init(fetchTVSeriesImageCollectionUseCase: some FetchTVSeriesImageCollectionUseCase) {
        self.fetchTVSeriesImageCollectionUseCase = fetchTVSeriesImageCollectionUseCase
    }

    func imageURLSet(forTVSeries tvSeriesID: Int) async throws(TVSeriesLogoImageProviderError)
    -> ImageURLSet? {
        let imageCollectionDetails: ImageCollectionDetails
        do {
            imageCollectionDetails = try await fetchTVSeriesImageCollectionUseCase.execute(
                tvSeriesID: tvSeriesID
            )
        } catch let error {
            throw TVSeriesLogoImageProviderError(error)
        }

        return imageCollectionDetails.logoURLSets.first
    }

}

private extension TVSeriesLogoImageProviderError {

    init(_ error: Error) {
        guard let error = error as? FetchTVSeriesImageCollectionError else {
            self = .unknown(error)
            return
        }

        switch error {
        case .notFound:
            self = .notFound
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

}
