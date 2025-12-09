//
//  DiscoverMovieRemoteDataSource.swift
//  PopcornDiscover
//
//  Created by Adam Young on 08/12/2025.
//

import Foundation

public protocol DiscoverRemoteDataSource: Sendable {

    func movies(
        filter: MovieFilter?,
        page: Int
    ) async throws(DiscoverRemoteDataSourceError) -> [MoviePreview]

    func tvSeries(
        filter: TVSeriesFilter?,
        page: Int
    ) async throws(DiscoverRemoteDataSourceError) -> [TVSeriesPreview]

}

public enum DiscoverRemoteDataSourceError: Error {

    case unauthorised
    case unknown(Error? = nil)

}
