//
//  TVSeriesLocalDataSource.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

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
