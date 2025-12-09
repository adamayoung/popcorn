//
//  DiscoverMovieRepository.swift
//  PopcornDiscover
//
//  Created by Adam Young on 28/05/2025.
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
