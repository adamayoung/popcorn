//
//  MovieRepository.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol MovieRepository: Sendable {

    func movie(withID id: Int) async throws(MovieRepositoryError) -> Movie

    func movieStream(withID id: Int) async -> AsyncThrowingStream<Movie?, Error>

}

public enum MovieRepositoryError: Error {

    case notFound
    case unauthorised
    case unknown(Error? = nil)

}
