//
//  DefaultTrendingRepository.swift
//  TrendingKit
//
//  Created by Adam Young on 28/05/2025.
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
    ) async throws(TrendingRepositoryError) -> [MoviePreview] {
        let movies = try await remoteDataSource.movies(page: page)

        return movies
    }

    func tvSeries(
        page: Int
    ) async throws(TrendingRepositoryError) -> [TVSeriesPreview] {
        let tvSeries = try await remoteDataSource.tvSeries(page: page)

        return tvSeries
    }

    func people(
        page: Int
    ) async throws(TrendingRepositoryError) -> [PersonPreview] {
        let people = try await remoteDataSource.people(page: page)

        return people
    }

}
