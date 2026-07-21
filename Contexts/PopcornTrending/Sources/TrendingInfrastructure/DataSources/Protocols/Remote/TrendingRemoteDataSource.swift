//
//  TrendingRemoteDataSource.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TrendingDomain

public protocol TrendingRemoteDataSource: Sendable {

    func movies(page: Int) async throws(TrendingRepositoryError) -> MoviePreviewPage

    func tvSeries(page: Int) async throws(TrendingRepositoryError) -> [TVSeriesPreview]

    func people(page: Int) async throws(TrendingRepositoryError) -> [PersonPreview]

}
