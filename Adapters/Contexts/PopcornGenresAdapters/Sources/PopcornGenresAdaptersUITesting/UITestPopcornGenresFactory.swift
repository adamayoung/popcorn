//
//  UITestPopcornGenresFactory.swift
//  PopcornGenresAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresApplication
import GenresComposition
import GenresDomain

public final class UITestPopcornGenresFactory: PopcornGenresFactory {

    private let applicationFactory: GenresApplicationFactory

    public init() {
        self.applicationFactory = GenresApplicationFactory(
            genreRepository: StubGenreRepository()
        )
    }

    public func makeFetchMovieGenresUseCase() -> FetchMovieGenresUseCase {
        applicationFactory.makeFetchMovieGenresUseCase()
    }

    public func makeFetchTVSeriesGenresUseCase() -> FetchTVSeriesGenresUseCase {
        applicationFactory.makeFetchTVSeriesGenresUseCase()
    }

}
