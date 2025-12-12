//
//  DefaultMovieRepository.swift
//  PopcornMovies
//
//  Created by Adam Young on 28/05/2025.
//

import Foundation
import MoviesDomain

final class DefaultMovieRepository: MovieRepository {

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
            let movie = try await remoteDataSource.movie(withID: id)
            try await localDataSource.setMovie(movie)
        }

        return stream
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
