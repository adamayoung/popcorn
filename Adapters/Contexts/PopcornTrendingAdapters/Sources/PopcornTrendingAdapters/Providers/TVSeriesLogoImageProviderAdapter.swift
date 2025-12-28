//
//  TVSeriesLogoImageProviderAdapter.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import TrendingDomain
import TVSeriesApplication

///
/// An adapter that provides TV series logo images for the Trending domain.
///
/// This adapter bridges the ``FetchTVSeriesImageCollectionUseCase`` to the
/// ``TVSeriesLogoImageProviding`` protocol required by the Trending domain.
///
final class TVSeriesLogoImageProviderAdapter: TVSeriesLogoImageProviding {

    private let fetchTVSeriesImageCollectionUseCase: any FetchTVSeriesImageCollectionUseCase

    ///
    /// Creates a new TV series logo image provider adapter.
    ///
    /// - Parameter fetchTVSeriesImageCollectionUseCase: The use case for fetching TV series image collections.
    ///
    init(fetchTVSeriesImageCollectionUseCase: some FetchTVSeriesImageCollectionUseCase) {
        self.fetchTVSeriesImageCollectionUseCase = fetchTVSeriesImageCollectionUseCase
    }

    ///
    /// Retrieves the logo image URL set for a TV series.
    ///
    /// - Parameter tvSeriesID: The unique identifier of the TV series.
    ///
    /// - Returns: The image URL set for the TV series' logo, or `nil` if no logo is available.
    ///
    /// - Throws: ``TVSeriesLogoImageProviderError`` if the image collection cannot be fetched.
    ///
    func imageURLSet(forTVSeries tvSeriesID: Int) async throws(TVSeriesLogoImageProviderError)
    -> ImageURLSet? {
        let imageCollectionDetails: ImageCollectionDetails
        do {
            imageCollectionDetails = try await fetchTVSeriesImageCollectionUseCase.execute(
                tvSeriesID: tvSeriesID)
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
