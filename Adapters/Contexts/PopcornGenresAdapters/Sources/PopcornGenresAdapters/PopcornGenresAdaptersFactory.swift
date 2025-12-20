//
//  PopcornGenresAdaptersFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresComposition
import TMDb

public final class PopcornGenresAdaptersFactory {

    private let genreService: any GenreService

    public init(genreService: some GenreService) {
        self.genreService = genreService
    }

    public func makeGenresFactory() -> PopcornGenresFactory {
        let genreRemoteDataSource = TMDbGenreRemoteDataSource(
            genreService: genreService
        )

        return PopcornGenresFactory(
            genreRemoteDataSource: genreRemoteDataSource
        )
    }

}
