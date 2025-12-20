//
//  MovieImageRepository.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol MovieImageRepository: Sendable {

    func imageCollection(forMovie movieID: Int) async throws(MovieImageRepositoryError)
        -> ImageCollection

    func imageCollectionStream(
        forMovie movieID: Int
    ) async -> AsyncThrowingStream<ImageCollection?, Error>

}

public enum MovieImageRepositoryError: Error {

    case notFound
    case unauthorised
    case unknown(Error? = nil)

}
