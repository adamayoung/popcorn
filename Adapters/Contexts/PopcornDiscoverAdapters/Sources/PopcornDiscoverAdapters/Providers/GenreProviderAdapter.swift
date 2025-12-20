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

struct GenreProviderAdapter: GenreProviding {

    private let fetchMovieGenresUseCase: any FetchMovieGenresUseCase
    private let fetchTVSeriesGenresUseCase: any FetchTVSeriesGenresUseCase

    init(
        fetchMovieGenresUseCase: some FetchMovieGenresUseCase,
        fetchTVSeriesGenresUseCase: some FetchTVSeriesGenresUseCase
    ) {
        self.fetchMovieGenresUseCase = fetchMovieGenresUseCase
        self.fetchTVSeriesGenresUseCase = fetchTVSeriesGenresUseCase
    }

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
