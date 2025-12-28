//
//  FetchTVSeriesGenresUseCase.swift
//  PopcornGenres
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresDomain

///
/// Defines the contract for fetching TV series genres.
///
/// This use case retrieves all available TV series genres from the repository,
/// handling caching and error translation automatically.
///
public protocol FetchTVSeriesGenresUseCase: Sendable {

    ///
    /// Fetches all available TV series genres.
    ///
    /// - Returns: An array of ``Genre`` instances representing TV series genres.
    /// - Throws: ``FetchTVSeriesGenresError`` if the genres cannot be fetched.
    ///
    func execute() async throws(FetchTVSeriesGenresError) -> [Genre]

}
