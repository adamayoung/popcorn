//
//  MovieTool.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
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

    @Generable
    struct Movie: PromptRepresentable {
        @Guide(description: "This is the ID of the movie.")
        let id: Int
        @Guide(description: "This is the title of the movie.")
        let title: String
        @Guide(description: "This is an overview of the movie.")
        let overview: String
        @Guide(description: "This is the release date of the movie.")
        let releaseDate: String?
    }

    func call(arguments: Arguments) async throws -> Movie {
        let movie = try await movieProvider.movie(withID: arguments.movieID)
        let mapper = MovieToolMapper()
        return mapper.map(movie)
    }

}
