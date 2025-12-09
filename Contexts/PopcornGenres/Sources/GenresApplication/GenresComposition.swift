//
//  GenresComposition.swift
//  PopcornGenres
//
//  Created by Adam Young on 09/12/2025.
//

import Foundation
import GenresDomain
import GenresInfrastructure

public struct GenresComposition {

    private init() {}

    public static func makeGenresFactory(
        genreRemoteDataSource: some GenreRemoteDataSource
    ) -> GenresApplicationFactory {
        let infrastructureFactory = GenresInfrastructureFactory(
            genreRemoteDataSource: genreRemoteDataSource
        )
        let genreRepository = infrastructureFactory.makeGenreRepository()

        return GenresApplicationFactory(
            genreRepository: genreRepository
        )
    }

}
