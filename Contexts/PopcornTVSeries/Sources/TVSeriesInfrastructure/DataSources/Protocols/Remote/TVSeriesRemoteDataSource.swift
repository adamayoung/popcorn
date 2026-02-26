//
//  TVSeriesRemoteDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

public protocol TVSeriesRemoteDataSource: Sendable {

    func tvSeries(withID id: Int) async throws(TVSeriesRemoteDataSourceError) -> TVSeries

    func images(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesRemoteDataSourceError) -> ImageCollection

    func credits(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesRemoteDataSourceError) -> Credits

    func aggregateCredits(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesRemoteDataSourceError) -> AggregateCredits

}

public enum TVSeriesRemoteDataSourceError: Error {

    case notFound
    case unauthorised
    case unknown(Error? = nil)

}
