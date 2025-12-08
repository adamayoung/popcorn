//
//  TMDbMovieRemoteDataSource.swift
//  MoviesKitAdapters
//
//  Created by Adam Young on 18/11/2025.
//

import Foundation
import MoviesDomain
import MoviesInfrastructure
import TMDb

final class TMDbMovieRemoteDataSource: MovieRemoteDataSource {

    private let movieService: any TMDb.MovieService

    init(movieService: some TMDb.MovieService) {
        self.movieService = movieService
    }

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

}

extension MovieRemoteDataSourceError {

    fileprivate init(_ error: Error) {
        guard let error = error as? TMDbError else {
            self = .unknown(error)
            return
        }

        self.init(error)
    }

    fileprivate init(_ error: TMDbError) {
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
