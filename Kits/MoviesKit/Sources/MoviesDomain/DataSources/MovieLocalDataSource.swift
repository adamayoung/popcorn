//
//  MovieLocalDataSource.swift
//  MoviesKit
//
//  Created by Adam Young on 24/11/2025.
//

import Foundation

public protocol MovieLocalDataSource: Sendable, Actor {

    func movie(withID id: Int) async throws(MovieLocalDataSourceError) -> Movie?

    func movieStream(forMovie id: Int) async -> AsyncThrowingStream<Movie?, Error>

    func setMovie(_ movie: Movie) async throws(MovieLocalDataSourceError)

}

public enum MovieLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
