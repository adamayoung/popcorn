//
//  TMDbMovieRemoteDataSource.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
import MoviesInfrastructure
import TMDb

///
/// A remote data source for fetching movie data from TMDb.
///
/// Implements ``MovieRemoteDataSource`` to provide movie data
/// by communicating with The Movie Database API.
///
final class TMDbMovieRemoteDataSource: MovieRemoteDataSource {

    private let movieService: any TMDb.MovieService

    ///
    /// Creates a TMDb movie remote data source.
    ///
    /// - Parameter movieService: The TMDb movie service for API communication.
    ///
    init(movieService: some TMDb.MovieService) {
        self.movieService = movieService
    }

    ///
    /// Fetches detailed information for a specific movie.
    ///
    /// - Parameter id: The unique identifier of the movie.
    ///
    /// - Returns: The movie with the specified identifier.
    ///
    /// - Throws: ``MovieRemoteDataSourceError`` if the movie cannot be fetched.
    ///
    func movie(withID id: Int) async throws(MovieRemoteDataSourceError) -> MoviesDomain.Movie {
        let tmdbMovie: TMDb.Movie
        do {
            tmdbMovie = try await movieService.details(forMovie: id, language: "en")
        } catch let error {
            throw MovieRemoteDataSourceError(error)
        }

        let mapper = MovieMapper()
        let movie = mapper.map(tmdbMovie)

        return movie
    }

    ///
    /// Fetches the image collection for a specific movie.
    ///
    /// - Parameter movieID: The unique identifier of the movie.
    ///
    /// - Returns: The image collection containing posters, backdrops, and logos.
    ///
    /// - Throws: ``MovieRemoteDataSourceError`` if the image collection cannot be fetched.
    ///
    func imageCollection(
        forMovie movieID: Int
    ) async throws(MovieRemoteDataSourceError) -> MoviesDomain.ImageCollection {
        let tmdbImageCollection: TMDb.ImageCollection
        do {
            tmdbImageCollection = try await movieService.images(
                forMovie: movieID,
                filter: .init(languages: ["en"])
            )
        } catch let error {
            throw MovieRemoteDataSourceError(error)
        }

        let mapper = ImageCollectionMapper()
        let imageCollection = mapper.map(tmdbImageCollection)

        return imageCollection
    }

    ///
    /// Fetches a page of popular movies.
    ///
    /// - Parameter page: The page number to fetch.
    ///
    /// - Returns: An array of movie previews for the requested page.
    ///
    /// - Throws: ``MovieRemoteDataSourceError`` if the popular movies cannot be fetched.
    ///
    func popular(page: Int) async throws(MovieRemoteDataSourceError) -> [MoviePreview] {
        let tmdbMovies: [TMDb.MovieListItem]
        do {
            tmdbMovies = try await movieService.popular(page: page, country: "GB", language: "en")
                .results
        } catch let error {
            throw MovieRemoteDataSourceError(error)
        }

        let mapper = MoviePreviewMapper()
        let movies = tmdbMovies.map(mapper.map)
        return movies
    }

    ///
    /// Fetches movies similar to a specific movie.
    ///
    /// - Parameters:
    ///   - movieID: The unique identifier of the movie to find similar movies for.
    ///   - page: The page number to fetch.
    ///
    /// - Returns: An array of movie previews similar to the specified movie.
    ///
    /// - Throws: ``MovieRemoteDataSourceError`` if the similar movies cannot be fetched.
    ///
    func similar(
        toMovie movieID: Int,
        page: Int
    ) async throws(MovieRemoteDataSourceError) -> [MoviePreview] {
        let tmdbMovies: [TMDb.MovieListItem]
        do {
            tmdbMovies = try await movieService.similar(
                toMovie: movieID, page: page, language: "en"
            ).results
        } catch let error {
            throw MovieRemoteDataSourceError(error)
        }

        let mapper = MoviePreviewMapper()
        let movies = tmdbMovies.map(mapper.map)
        return movies
    }

    ///
    /// Fetches movie recommendations based on a specific movie.
    ///
    /// - Parameters:
    ///   - movieID: The unique identifier of the movie to get recommendations for.
    ///   - page: The page number to fetch.
    ///
    /// - Returns: An array of recommended movie previews.
    ///
    /// - Throws: ``MovieRemoteDataSourceError`` if the recommendations cannot be fetched.
    ///
    func recommendations(
        forMovie movieID: Int,
        page: Int
    ) async throws(MovieRemoteDataSourceError) -> [MoviePreview] {
        let tmdbMovies: [TMDb.MovieListItem]
        do {
            tmdbMovies = try await movieService.recommendations(
                forMovie: movieID, page: page, language: "en"
            ).results
        } catch let error {
            throw MovieRemoteDataSourceError(error)
        }

        let mapper = MoviePreviewMapper()
        let movies = tmdbMovies.map(mapper.map)
        return movies
    }

}

private extension MovieRemoteDataSourceError {

    init(_ error: Error) {
        guard let error = error as? TMDbError else {
            self = .unknown(error)
            return
        }

        self.init(error)
    }

    init(_ error: TMDbError) {
        switch error {
        case .notFound:
            self = .notFound
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

}
