//
//  GenreBackdropProviderAdapter.swift
//  PopcornGenresAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GenresDomain
import TMDb

final class GenreBackdropProviderAdapter: GenreBackdropProviding {

    private let discoverService: any DiscoverService

    init(discoverService: some DiscoverService) {
        self.discoverService = discoverService
    }

    func backdropPath(forGenreID genreID: GenresDomain.Genre.ID) async throws(GenreBackdropProviderError) -> URL? {
        let movieBackdrop = try await fetchMovieBackdrop(forGenreID: genreID)
        if let movieBackdrop {
            return movieBackdrop
        }

        return try await fetchTVSeriesBackdrop(forGenreID: genreID)
    }

}

extension GenreBackdropProviderAdapter {

    private func fetchMovieBackdrop(forGenreID genreID: Int) async throws(GenreBackdropProviderError) -> URL? {
        let movies: MoviePageableList
        do {
            let filter = DiscoverMovieFilter(genres: [genreID])
            movies = try await discoverService.movies(filter: filter, sortedBy: nil, page: 1, language: nil)
        } catch let error {
            throw GenreBackdropProviderError(error)
        }

        return movies.results.first?.backdropPath
    }

    private func fetchTVSeriesBackdrop(forGenreID genreID: Int) async throws(GenreBackdropProviderError) -> URL? {
        let tvSeries: TVSeriesPageableList
        do {
            let filter = DiscoverTVSeriesFilter(genres: [genreID])
            tvSeries = try await discoverService.tvSeries(
                filter: filter, sortedBy: nil, page: 1, language: nil
            )
        } catch let error {
            throw GenreBackdropProviderError(error)
        }

        return tvSeries.results.first?.backdropPath
    }

}

private extension GenreBackdropProviderError {

    init(_ error: Error) {
        guard let error = error as? TMDbError else {
            self = .unknown(error)
            return
        }

        switch error {
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

}
