//
//  TrendingRepository.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol TrendingRepository: Sendable {

    func movies(page: Int) async throws(TrendingRepositoryError) -> MoviePreviewPage

    func tvSeries(page: Int) async throws(TrendingRepositoryError) -> [TVSeriesPreview]

    func people(page: Int) async throws(TrendingRepositoryError) -> [PersonPreview]

}

public enum TrendingRepositoryError: Error {

    case unauthorised
    case unknown(Error?)

}
