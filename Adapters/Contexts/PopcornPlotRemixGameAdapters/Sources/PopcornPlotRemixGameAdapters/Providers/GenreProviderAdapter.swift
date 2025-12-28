//
//  GenreProviderAdapter.swift
//  PopcornPlotRemixGameAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresApplication
import GenresDomain
import PlotRemixGameDomain
import PopcornGenresAdapters

///
/// An adapter that provides genres for the plot remix game domain.
///
/// Bridges the genres application layer to the plot remix game domain by
/// wrapping the ``FetchMovieGenresUseCase``.
///
public struct GenreProviderAdapter: GenreProviding {

    private let fetchMovieGenresUseCase: any FetchMovieGenresUseCase

    ///
    /// Creates a genre provider adapter.
    ///
    /// - Parameter fetchMovieGenresUseCase: The use case for fetching movie genres.
    ///
    public init(fetchMovieGenresUseCase: some FetchMovieGenresUseCase) {
        self.fetchMovieGenresUseCase = fetchMovieGenresUseCase
    }

    ///
    /// Fetches available movie genres.
    ///
    /// - Returns: An array of movie genres.
    /// - Throws: ``GenreProviderError`` if the genres cannot be fetched.
    ///
    public func movies() async throws(GenreProviderError) -> [PlotRemixGameDomain.Genre] {
        let genres: [GenresDomain.Genre]
        do {
            genres = try await fetchMovieGenresUseCase.execute()
        } catch let error {
            throw GenreProviderError(error)
        }

        return genres.map { genre in
            PlotRemixGameDomain.Genre(id: genre.id, name: genre.name)
        }
    }

}

extension GenreProviderError {

    init(_ error: FetchMovieGenresError) {
        switch error {
        case .unauthorised: self = .unauthorised
        case .unknown(let error): self = .unknown(error)
        }
    }

}
