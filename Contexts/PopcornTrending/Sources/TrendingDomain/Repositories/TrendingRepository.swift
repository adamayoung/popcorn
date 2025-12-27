//
//  TrendingRepository.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol TrendingRepository: Sendable {

    func movies(
        page: Int,
        cachePolicy: CachePolicy
    ) async throws(TrendingRepositoryError) -> [MoviePreview]

    func tvSeries(
        page: Int,
        cachePolicy: CachePolicy
    ) async throws(TrendingRepositoryError) -> [TVSeriesPreview]

    func people(
        page: Int,
        cachePolicy: CachePolicy
    ) async throws(TrendingRepositoryError) -> [PersonPreview]

}

public extension TrendingRepository {

    func movies(page: Int) async throws(TrendingRepositoryError) -> [MoviePreview] {
        try await movies(page: page, cachePolicy: .cacheFirst)
    }

    func tvSeries(page: Int) async throws(TrendingRepositoryError) -> [TVSeriesPreview] {
        try await tvSeries(page: page, cachePolicy: .cacheFirst)
    }

    func people(page: Int) async throws(TrendingRepositoryError) -> [PersonPreview] {
        try await people(page: page, cachePolicy: .cacheFirst)
    }

}

public enum TrendingRepositoryError: Error {

    case cacheUnavailable
    case unauthorised
    case unknown(Error?)

}
