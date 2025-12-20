//
//  DiscoverMovieRepository.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol DiscoverMovieRepository: Sendable {

    func movies(
        filter: MovieFilter?,
        page: Int
    ) async throws(DiscoverMovieRepositoryError) -> [MoviePreview]

}

public enum DiscoverMovieRepositoryError: Error {

    case unauthorised
    case unknown(Error?)

}
