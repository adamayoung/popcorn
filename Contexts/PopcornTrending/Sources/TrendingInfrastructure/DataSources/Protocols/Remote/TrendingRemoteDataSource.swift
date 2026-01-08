//
//  TrendingRemoteDataSource.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TrendingDomain

public protocol TrendingRemoteDataSource: Sendable {

    func movies(page: Int) async throws(TrendingRepositoryError) -> [MoviePreview]

    func tvSeries(page: Int) async throws(TrendingRepositoryError) -> [TVSeriesPreview]

    func people(page: Int) async throws(TrendingRepositoryError) -> [PersonPreview]

}
