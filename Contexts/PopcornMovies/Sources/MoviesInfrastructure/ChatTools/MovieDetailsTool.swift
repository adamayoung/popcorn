//
//  MovieDetailsTool.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import FoundationModels
import MoviesDomain

/// A tool that provides detailed information about a specific movie
public struct MovieDetailsTool: Tool {

    public let name = "getMovieDetails"
    public let description = """
    Fetch detailed information about the current movie including title, overview, and release date
    """

    @Generable
    public struct Arguments {
        public init() {}
    }

    private let movieID: Int
    private let movieRepository: any MovieRepository

    public init(movieID: Int, movieRepository: any MovieRepository) {
        self.movieID = movieID
        self.movieRepository = movieRepository
    }

    public func call(arguments: Arguments) async throws -> String {
        let movie = try await movieRepository.movie(withID: movieID)

        let releaseDateString = movie.releaseDate.map {
            $0.formatted(date: .long, time: .omitted)
        } ?? "Unknown"

        return """
        Title: \(movie.title)
        Release Date: \(releaseDateString)
        Overview: \(movie.overview)
        """
    }

}
