//
//  TrendingRepository.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol TrendingRepository: Sendable {

    func movies(page: Int) async throws(TrendingRepositoryError) -> [MoviePreview]

    func tvSeries(page: Int) async throws(TrendingRepositoryError) -> [TVSeriesPreview]

    func people(page: Int) async throws(TrendingRepositoryError) -> [PersonPreview]

}

public enum TrendingRepositoryError: Error {

    case unauthorised
    case unknown(Error?)

}
