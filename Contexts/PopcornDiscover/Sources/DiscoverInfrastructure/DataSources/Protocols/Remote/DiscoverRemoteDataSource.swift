//
//  DiscoverRemoteDataSource.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import DiscoverDomain
import Foundation

public protocol DiscoverRemoteDataSource: Sendable {

    func movies(
        filter: MovieFilter?,
        page: Int
    ) async throws(DiscoverRemoteDataSourceError) -> MoviePreviewPage

    func tvSeries(
        filter: TVSeriesFilter?,
        page: Int
    ) async throws(DiscoverRemoteDataSourceError) -> [TVSeriesPreview]

}

public enum DiscoverRemoteDataSourceError: Error {

    case unauthorised
    case unknown(Error? = nil)

}
