//
//  PopcornGenresAdaptersFactory.swift
//  PopcornGenresAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresComposition
import TMDb

///
/// A factory for creating genre-related adapters.
///
/// Creates adapters that bridge TMDb genre services to the application's
/// genres domain.
///
public final class PopcornGenresAdaptersFactory {

    private let genreService: any GenreService

    ///
    /// Creates a genres adapters factory.
    ///
    /// - Parameter genreService: The TMDb genre service.
    ///
    public init(genreService: some GenreService) {
        self.genreService = genreService
    }

    ///
    /// Creates a genres factory with configured adapters.
    ///
    /// - Returns: A configured ``PopcornGenresFactory`` instance.
    ///
    public func makeGenresFactory() -> PopcornGenresFactory {
        let genreRemoteDataSource = TMDbGenreRemoteDataSource(
            genreService: genreService
        )

        return PopcornGenresFactory(
            genreRemoteDataSource: genreRemoteDataSource
        )
    }

}
