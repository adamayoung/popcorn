//
//  GenreProviderAdapter.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation
import GenresApplication
import GenresDomain

///
/// An adapter that provides genre data for the discover domain.
///
/// Bridges the genres application layer to the discover domain by wrapping
/// the ``FetchMovieGenresUseCase`` and ``FetchTVSeriesGenresUseCase``.
///
final class GenreProviderAdapter: GenreProviding {

    private let fetchMovieGenresUseCase: any FetchMovieGenresUseCase
    private let fetchTVSeriesGenresUseCase: any FetchTVSeriesGenresUseCase

    ///
    /// Creates a genre provider adapter.
    ///
    /// - Parameters:
    ///   - fetchMovieGenresUseCase: The use case for fetching movie genres.
    ///   - fetchTVSeriesGenresUseCase: The use case for fetching TV series genres.
    ///
    init(
        fetchMovieGenresUseCase: some FetchMovieGenresUseCase,
        fetchTVSeriesGenresUseCase: some FetchTVSeriesGenresUseCase
    ) {
        self.fetchMovieGenresUseCase = fetchMovieGenresUseCase
        self.fetchTVSeriesGenresUseCase = fetchTVSeriesGenresUseCase
    }

    ///
    /// Fetches the list of movie genres.
    ///
    /// - Returns: An array of genres for movies.
    /// - Throws: ``GenreProviderError`` if the genres cannot be fetched.
    ///
    func movieGenres() async throws(GenreProviderError) -> [DiscoverDomain.Genre] {
        let genres: [GenresDomain.Genre]
        do {
            genres = try await fetchMovieGenresUseCase.execute()
        } catch let error {
            throw GenreProviderError(error)
        }

        let mapper = GenreMapper()
        return genres.map(mapper.map)
    }

    ///
    /// Fetches the list of TV series genres.
    ///
    /// - Returns: An array of genres for TV series.
    /// - Throws: ``GenreProviderError`` if the genres cannot be fetched.
    ///
    func tvSeriesGenres() async throws(DiscoverDomain.GenreProviderError) -> [DiscoverDomain.Genre] {
        let genres: [GenresDomain.Genre]
        do {
            genres = try await fetchTVSeriesGenresUseCase.execute()
        } catch let error {
            throw GenreProviderError(error)
        }

        let mapper = GenreMapper()
        return genres.map(mapper.map)
    }

}

private extension GenreProviderError {

    init(_ error: Error) {
        if let error = error as? FetchMovieGenresError {
            self.init(error)
            return
        }

        if let error = error as? FetchTVSeriesGenresError {
            self.init(error)
            return
        }

        self = .unknown(error)
    }

    init(_ error: FetchMovieGenresError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

    init(_ error: FetchTVSeriesGenresError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

}
