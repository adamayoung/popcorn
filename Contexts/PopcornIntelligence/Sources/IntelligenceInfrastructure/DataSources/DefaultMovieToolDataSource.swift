//
//  DefaultMovieToolDataSource.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import FoundationModels
import IntelligenceDomain

///
/// Default implementation of the movie tool data source
///
/// Provides LLM tools configured with the movie provider for fetching movie information.
///
final class DefaultMovieToolDataSource: MovieToolDataSource {

    private let movieProvider: any MovieProviding
    private let creditsProvider: any CreditsProviding

    init(
        movieProvider: some MovieProviding,
        creditsProvider: some CreditsProviding
    ) {
        self.movieProvider = movieProvider
        self.creditsProvider = creditsProvider
    }

    func movie() -> any Tool {
        MovieTool(movieProvider: movieProvider)
    }

    func movieCredits() -> any Tool {
        MovieCreditsTool(creditsProvider: creditsProvider)
    }

}
