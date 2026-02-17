//
//  MovieCreditsTool.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import FoundationModels
import IntelligenceDomain

final class MovieCreditsTool: Tool {

    private let creditsProvider: any CreditsProviding

    let name = "fetchMovieCredits"
    let description = "Fetch the top listed credits (cast and crew) of a movie."

    init(creditsProvider: some CreditsProviding) {
        self.creditsProvider = creditsProvider
    }

    @Generable
    struct Arguments {
        @Guide(description: "This is the ID of the movie of the credits to fetch.")
        let movieID: Int
    }

    func call(arguments: MovieCreditsTool.Arguments) async throws -> MovieCreditsToolCredits {
        let credits = try await creditsProvider.credits(forMovie: arguments.movieID)
        let mapper = MovieCreditsToolMapper()
        return mapper.map(credits, limit: 10)
    }

}
