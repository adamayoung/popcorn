//
//  TrendingRemoteDataSource.swift
//  TrendingKit
//
//  Created by Adam Young on 29/05/2025.
//

import Foundation

public protocol TrendingRemoteDataSource: Sendable {

    func movies(page: Int) async throws(TrendingRepositoryError) -> [MoviePreview]

    func tvSeries(page: Int) async throws(TrendingRepositoryError) -> [TVSeriesPreview]

    func people(page: Int) async throws(TrendingRepositoryError) -> [PersonPreview]

}
