//
//  MovieTool.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import FoundationModels
import IntelligenceDomain

///
/// LLM tool that fetches movie details from the movie provider
///
/// This tool enables the LLM to retrieve detailed information about movies
/// including title, overview, and release date.
///
final class MovieTool: Tool {

    private let movieProvider: any MovieProviding

    let name = "fetchMovieDetails"
    let description = "Fetch details about a movie."

    init(movieProvider: some MovieProviding) {
        self.movieProvider = movieProvider
    }

    @Generable
    struct Arguments {
        @Guide(description: "This is the ID of the movie to fetch.")
        let movieID: Int
    }

    func call(arguments: Arguments) async throws -> MovieToolMovie {
        let movie = try await movieProvider.movie(withID: arguments.movieID)
        let mapper = MovieToolMapper()
        return mapper.map(movie)
    }

}
