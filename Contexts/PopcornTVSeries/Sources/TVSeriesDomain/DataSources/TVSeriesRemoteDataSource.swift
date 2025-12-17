//
//  TVSeriesRemoteDataSource.swift
//  PopcornTVSeries
//
//  Created by Adam Young on 18/11/2025.
//

import Foundation

public protocol TVSeriesRemoteDataSource: Sendable {

    func tvSeries(withID id: Int) async throws(TVSeriesRemoteDataSourceError) -> TVSeries

    func images(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesRemoteDataSourceError) -> ImageCollection

}

public enum TVSeriesRemoteDataSourceError: Error {

    case notFound
    case unauthorised
    case unknown(Error? = nil)

}
