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

public struct GenreProviderAdapter: GenreProviding {

    private let fetchMovieGenresUseCase: any FetchMovieGenresUseCase

    public init(fetchMovieGenresUseCase: some FetchMovieGenresUseCase) {
        self.fetchMovieGenresUseCase = fetchMovieGenresUseCase
    }

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
