//
//  TMDbMovieRemoteDataSource.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
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
        return mapper.map(tmdbMovie)
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
        return mapper.map(tmdbImageCollection)
    }

    func popular(page: Int) async throws(MovieRemoteDataSourceError) -> [MoviePreview] {
        let tmdbMovies: [TMDb.MovieListItem]
        do {
            tmdbMovies = try await movieService.popular(page: page)
                .results
        } catch let error {
            throw MovieRemoteDataSourceError(error)
        }

        let mapper = MoviePreviewMapper()
        return tmdbMovies.map(mapper.map)
    }

    func similar(
        toMovie movieID: Int,
        page: Int
    ) async throws(MovieRemoteDataSourceError) -> [MoviePreview] {
        let tmdbMovies: [TMDb.MovieListItem]
        do {
            tmdbMovies = try await movieService.similar(
                toMovie: movieID, page: page
            ).results
        } catch let error {
            throw MovieRemoteDataSourceError(error)
        }

        let mapper = MoviePreviewMapper()
        return tmdbMovies.map(mapper.map)
    }

    func recommendations(
        forMovie movieID: Int,
        page: Int
    ) async throws(MovieRemoteDataSourceError) -> [MoviePreview] {
        let tmdbMovies: [TMDb.MovieListItem]
        do {
            tmdbMovies = try await movieService.recommendations(
                forMovie: movieID, page: page
            ).results
        } catch let error {
            throw MovieRemoteDataSourceError(error)
        }

        let mapper = MoviePreviewMapper()
        return tmdbMovies.map(mapper.map)
    }

    func credits(forMovie movieID: Int) async throws(MovieRemoteDataSourceError) -> Credits {
        let tmdbCredits: TMDb.ShowCredits
        do {
            tmdbCredits = try await movieService.credits(forMovie: movieID)
        } catch let error {
            throw MovieRemoteDataSourceError(error)
        }

        let mapper = CreditsMapper()
        return mapper.map(tmdbCredits)
    }

    func certification(forMovie movieID: Int) async throws(MovieRemoteDataSourceError) -> String {
        let tmdbReleaseDatesByCountry: [MovieReleaseDatesByCountry]
        do {
            tmdbReleaseDatesByCountry = try await movieService.releaseDates(forMovie: movieID)
        } catch let error {
            throw MovieRemoteDataSourceError(error)
        }

        let countryCode = Locale.current.region?.identifier ?? "US"
        let releaseDates = tmdbReleaseDatesByCountry.first { $0.countryCode == countryCode }?.releaseDates
            ?? tmdbReleaseDatesByCountry.first { $0.countryCode == "US" }?.releaseDates

        guard let releaseDates else {
            throw .notFound
        }

        guard let firstReleaseDate = releaseDates.first(where: { !$0.certification.isEmpty }) else {
            throw .notFound
        }

        return firstReleaseDate.certification
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
