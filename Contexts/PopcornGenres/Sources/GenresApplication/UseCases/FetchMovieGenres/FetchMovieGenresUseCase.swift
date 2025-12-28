//
//  FetchMovieGenresUseCase.swift
//  PopcornGenres
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresDomain

///
/// Defines the contract for fetching movie genres.
///
/// This use case retrieves all available movie genres from the repository,
/// handling caching and error translation automatically.
///
public protocol FetchMovieGenresUseCase: Sendable {

    ///
    /// Fetches all available movie genres.
    ///
    /// - Returns: An array of ``Genre`` instances representing movie genres.
    /// - Throws: ``FetchMovieGenresError`` if the genres cannot be fetched.
    ///
    func execute() async throws(FetchMovieGenresError) -> [Genre]

}
