//
//  DefaultTrendingRepository.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TrendingDomain

final class DefaultTrendingRepository: TrendingRepository {

    private let remoteDataSource: any TrendingRemoteDataSource

    init(remoteDataSource: some TrendingRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func movies(
        page: Int
    ) async throws(TrendingRepositoryError) -> MoviePreviewPage {
        try await remoteDataSource.movies(page: page)
    }

    func tvSeries(
        page: Int
    ) async throws(TrendingRepositoryError) -> [TVSeriesPreview] {
        try await remoteDataSource.tvSeries(page: page)
    }

    func people(
        page: Int
    ) async throws(TrendingRepositoryError) -> [PersonPreview] {
        try await remoteDataSource.people(page: page)
    }

}
