//
//  PopcornGenresAdaptersFactory.swift
//  PopcornGenresAdapters
//
//  Created by Adam Young on 26/11/2025.
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
