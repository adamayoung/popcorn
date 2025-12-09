//
//  PopcornGenresAdaptersFactory.swift
//  PopcornGenresAdapters
//
//  Created by Adam Young on 26/11/2025.
//

import Foundation
import GenresApplication
import TMDb

struct PopcornGenresAdaptersFactory {

    let genreService: any GenreService

    func makeGenresFactory() -> GenresApplicationFactory {
        let genreRemoteDataSource = TMDbGenreRemoteDataSource(
            genreService: genreService
        )

        return GenresComposition.makeGenresFactory(
            genreRemoteDataSource: genreRemoteDataSource
        )
    }

}
