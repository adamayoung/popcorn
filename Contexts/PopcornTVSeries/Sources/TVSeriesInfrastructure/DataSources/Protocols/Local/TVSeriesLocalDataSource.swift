//
//  TVSeriesLocalDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

public protocol TVSeriesLocalDataSource: Sendable, Actor {

    func tvSeries(withID id: Int) async throws(TVSeriesLocalDataSourceError) -> TVSeries?

    func setTVSeries(_ tvSeries: TVSeries) async throws(TVSeriesLocalDataSourceError)

    func images(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesLocalDataSourceError) -> ImageCollection?

    func setImages(
        _ imageCollection: ImageCollection,
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesLocalDataSourceError)

}

public enum TVSeriesLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
