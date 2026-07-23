//
//  StreamTVSeriesDetailsUseCase.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// A use case that streams detailed TV series information, re-emitting as the
/// underlying data changes (for example, once a background refresh caches fresh
/// data and its extracted theme colour).
public protocol StreamTVSeriesDetailsUseCase: Sendable {

    /// Creates a stream of ``TVSeriesDetails`` for a TV series.
    ///
    /// - Parameter id: The unique identifier of the TV series to observe.
    /// - Returns: An async throwing stream emitting ``TVSeriesDetails``, or `nil` when the
    ///   series is not yet available.
    func stream(id: Int) async -> AsyncThrowingStream<TVSeriesDetails?, Error>

}
