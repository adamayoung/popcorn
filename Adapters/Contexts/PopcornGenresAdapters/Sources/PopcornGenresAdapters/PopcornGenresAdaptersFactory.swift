//
//  PopcornGenresAdaptersFactory.swift
//  PopcornGenresAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GenresComposition
import TMDb

public final class PopcornGenresAdaptersFactory {

    private let genreService: any GenreService

    public init(genreService: some GenreService) {
        self.genreService = genreService
    }

    public func makeGenresFactory() -> some PopcornGenresFactory {
        let genreRemoteDataSource = TMDbGenreRemoteDataSource(
            genreService: genreService
        )

        return LivePopcornGenresFactory(
            genreRemoteDataSource: genreRemoteDataSource
        )
    }

}
