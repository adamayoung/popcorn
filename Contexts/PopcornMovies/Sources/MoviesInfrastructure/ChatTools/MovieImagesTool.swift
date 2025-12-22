//
//  MovieImagesTool.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import FoundationModels
import MoviesDomain

/// A tool that provides image URLs for a specific movie
public struct MovieImagesTool: Tool {

    public let name = "getMovieImages"
    public let description = "Get URLs for movie posters and backdrops"

    @Generable
    public struct Arguments {
        @Guide(description: "Type of image: poster or backdrop")
        public var imageType: String

        public init(imageType: String = "poster") {
            self.imageType = imageType
        }
    }

    private let movieID: Int
    private let movieImageRepository: any MovieImageRepository

    public init(movieID: Int, movieImageRepository: any MovieImageRepository) {
        self.movieID = movieID
        self.movieImageRepository = movieImageRepository
    }

    public func call(arguments: Arguments) async throws -> String {
        let imageCollection = try await movieImageRepository.imageCollection(forMovie: movieID)

        switch arguments.imageType.lowercased() {
        case "poster":
            let urls = imageCollection.posterPaths.map(\.absoluteString)
            return urls.isEmpty ? "No posters available" : urls.joined(separator: "\n")

        case "backdrop":
            let urls = imageCollection.backdropPaths.map(\.absoluteString)
            return urls.isEmpty ? "No backdrops available" : urls.joined(separator: "\n")

        default:
            return "Unknown image type '\(arguments.imageType)'. Use 'poster' or 'backdrop'"
        }
    }

}
