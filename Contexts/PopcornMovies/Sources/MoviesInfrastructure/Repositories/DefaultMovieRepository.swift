//
//  DefaultMovieRepository.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
import OSLog

final class DefaultMovieRepository: MovieRepository {

    private static let logger = Logger.moviesInfrastructure

    private let remoteDataSource: any MovieRemoteDataSource
    private let localDataSource: any MovieLocalDataSource

    init(
        remoteDataSource: some MovieRemoteDataSource,
        localDataSource: any MovieLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func movie(withID id: Int) async throws(MovieRepositoryError) -> Movie {
        do {
            if let cachedMovie = try await localDataSource.movie(withID: id) {
                return cachedMovie
            }
        } catch let error {
            throw MovieRepositoryError(error)
        }

        let movie: Movie
        do { movie = try await remoteDataSource.movie(withID: id) } catch let error {
            throw MovieRepositoryError(error)
        }

        do { try await localDataSource.setMovie(movie) } catch let error {
            throw MovieRepositoryError(error)
        }

        return movie
    }

    func movieStream(withID id: Int) async -> AsyncThrowingStream<Movie?, Error> {
        let stream = await localDataSource.movieStream(forMovie: id)

        Task {
            do {
                let movie = try await remoteDataSource.movie(withID: id)
                try await localDataSource.setMovie(movie)
            } catch {
                Self.logger.error("Failed to fetch/cache movie in stream [movieID: \(id)]: \(error)")
            }
        }

        return stream
    }

    func certification(forMovie movieID: Int) async throws(MovieRepositoryError) -> String {
        do {
            if let cachedCertification = try await localDataSource.certification(forMovie: movieID) {
                return cachedCertification
            }
        } catch let error {
            throw MovieRepositoryError(error)
        }

        let certification: String
        do {
            certification = try await remoteDataSource.certification(forMovie: movieID)
        } catch let error {
            throw MovieRepositoryError(error)
        }

        do {
            try await localDataSource.setCertification(certification, forMovie: movieID)
        } catch let error {
            throw MovieRepositoryError(error)
        }

        return certification
    }

}

extension MovieRepositoryError {

    init(_ error: MovieLocalDataSourceError) {
        switch error {
        case .persistence(let error):
            self = .unknown(error)
        case .unknown(let error):
            self = .unknown(error)
        }
    }

    init(_ error: MovieRemoteDataSourceError) {
        switch error {
        case .notFound:
            self = .notFound
        case .unauthorised:
            self = .unauthorised
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
