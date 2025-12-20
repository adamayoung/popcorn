//
//  PopularMovieRepository.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol PopularMovieRepository: Sendable {

    func popular(page: Int) async throws(PopularMovieRepositoryError) -> [MoviePreview]

    func popularStream() async -> AsyncThrowingStream<[MoviePreview]?, Error>

    func nextPopularStreamPage() async throws(PopularMovieRepositoryError)

}

public enum PopularMovieRepositoryError: Error {

    case notFound
    case unauthorised
    case unknown(Error? = nil)

}
