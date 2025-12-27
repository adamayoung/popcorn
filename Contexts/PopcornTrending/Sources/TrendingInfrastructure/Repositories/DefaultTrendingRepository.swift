//
//  DefaultTrendingRepository.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TrendingDomain

final class DefaultTrendingRepository: TrendingRepository {

    private let remoteDataSource: any TrendingRemoteDataSource

    init(remoteDataSource: some TrendingRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func movies(
        page: Int,
        cachePolicy: CachePolicy = .cacheFirst
    ) async throws(TrendingRepositoryError) -> [MoviePreview] {
        // Trending is remote-only, no local cache
        switch cachePolicy {
        case .cacheFirst, .networkOnly:
            let movies = try await remoteDataSource.movies(page: page)
            return movies

        case .cacheOnly:
            throw .cacheUnavailable
        }
    }

    func tvSeries(
        page: Int,
        cachePolicy: CachePolicy = .cacheFirst
    ) async throws(TrendingRepositoryError) -> [TVSeriesPreview] {
        // Trending is remote-only, no local cache
        switch cachePolicy {
        case .cacheFirst, .networkOnly:
            let tvSeries = try await remoteDataSource.tvSeries(page: page)
            return tvSeries

        case .cacheOnly:
            throw .cacheUnavailable
        }
    }

    func people(
        page: Int,
        cachePolicy: CachePolicy = .cacheFirst
    ) async throws(TrendingRepositoryError) -> [PersonPreview] {
        // Trending is remote-only, no local cache
        switch cachePolicy {
        case .cacheFirst, .networkOnly:
            let people = try await remoteDataSource.people(page: page)
            return people

        case .cacheOnly:
            throw .cacheUnavailable
        }
    }

}
