//
//  MovieLocalDataSource.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

public protocol MovieLocalDataSource: Sendable, Actor {

    func movie(withID id: Int) async throws(MovieLocalDataSourceError) -> Movie?

    func movieStream(forMovie id: Int) async -> AsyncThrowingStream<Movie?, Error>

    func setMovie(_ movie: Movie) async throws(MovieLocalDataSourceError)

    func certification(forMovie movieID: Int) async throws(MovieLocalDataSourceError) -> String?

    func setCertification(_ certification: String, forMovie movieID: Int) async throws(MovieLocalDataSourceError)

}

public enum MovieLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
