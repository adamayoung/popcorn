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

    /// Creates a stream that emits the cached TV series and re-emits whenever the
    /// underlying store changes.
    ///
    /// - Parameter id: The unique identifier of the TV series to observe.
    /// - Returns: An async throwing stream that emits the cached ``TVSeries``, or `nil` when absent.
    func tvSeriesStream(forTVSeries id: Int) async -> AsyncThrowingStream<TVSeries?, Error>

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
