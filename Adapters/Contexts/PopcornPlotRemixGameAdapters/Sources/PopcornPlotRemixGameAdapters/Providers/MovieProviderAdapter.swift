//
//  MovieProviderAdapter.swift
//  PopcornPlotRemixGameAdapters
//
//  Created by Adam Young on 11/12/2025.
//

import DiscoverApplication
import Foundation
import PlotRemixGameDomain

public struct MovieProviderAdapter: MovieProviding {

    private let fetchDiscoverMoviesUseCase: any FetchDiscoverMoviesUseCase

    public init(fetchDiscoverMoviesUseCase: some FetchDiscoverMoviesUseCase) {
        self.fetchDiscoverMoviesUseCase = fetchDiscoverMoviesUseCase
    }

    public func randomMovies(filter: MovieFilter, limit: Int) async throws(MovieProviderError)
        -> [Movie]
    {
        let moviePreviewDetails: [MoviePreviewDetails]
        do {
            moviePreviewDetails = try await fetchDiscoverMoviesUseCase.execute()
        } catch let error {
            throw MovieProviderError(error)
        }

        return moviePreviewDetails.prefix(limit).map {
            Movie(
                id: $0.id,
                title: $0.title,
                overview: $0.overview,
                posterPath: $0.posterURLSet?.path,
                backdropPath: $0.backdropURLSet?.path
            )
        }
    }

}

extension MovieProviderError {

    init(_ error: FetchDiscoverMoviesError) {
        switch error {
        case .unauthorised: self = .unauthorised
        case .unknown(let error): self = .unknown(error)
        }
    }

}
