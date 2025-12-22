//
//  MovieRecommendationsTool.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import FoundationModels
import MoviesDomain

/// A tool that provides movie recommendations similar to a specific movie
public struct MovieRecommendationsTool: Tool {

    public let name = "getMovieRecommendations"
    public let description = "Get movie recommendations similar to the current movie"

    @Generable
    public struct Arguments {
        @Guide(description: "Number of recommendations to fetch", .range(1 ... 10))
        public var limit: Int

        public init(limit: Int = 5) {
            self.limit = limit
        }
    }

    private let movieID: Int
    private let similarMovieRepository: any SimilarMovieRepository

    public init(movieID: Int, similarMovieRepository: any SimilarMovieRepository) {
        self.movieID = movieID
        self.similarMovieRepository = similarMovieRepository
    }

    public func call(arguments: Arguments) async throws -> String {
        var recommendations: [MoviePreview] = []

        do {
            for try await movies in await similarMovieRepository.similarStream(
                toMovie: movieID,
                limit: arguments.limit
            ) {
                if let movies {
                    recommendations = movies
                    break
                }
            }
        } catch {
            throw SimilarMovieRepositoryError.unknown(error)
        }

        if recommendations.isEmpty {
            return "No recommendations available"
        }

        return recommendations.map { movie in
            let year = movie.releaseDate.map {
                $0.formatted(.dateTime.year())
            } ?? ""
            return year.isEmpty ? movie.title : "\(movie.title) (\(year))"
        }.joined(separator: "\n")
    }

}
