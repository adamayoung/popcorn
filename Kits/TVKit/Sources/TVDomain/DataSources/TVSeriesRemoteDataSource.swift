//
//  TVSeriesRemoteDataSource.swift
//  TVKit
//
//  Created by Adam Young on 18/11/2025.
//

import Foundation

public protocol TVSeriesRemoteDataSource: Sendable {

    func tvSeries(withID id: Int) async throws(TVSeriesRepositoryError) -> TVSeries

    func images(forTVSeries tvSeriesID: Int) async throws(TVSeriesRepositoryError)
        -> ImageCollection

}
