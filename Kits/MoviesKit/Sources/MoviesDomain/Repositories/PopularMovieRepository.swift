//
//  PopularMovieRepository.swift
//  MoviesKit
//
//  Created by Adam Young on 03/12/2025.
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
