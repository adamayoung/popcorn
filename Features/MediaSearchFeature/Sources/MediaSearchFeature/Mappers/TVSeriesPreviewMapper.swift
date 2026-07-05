//
//  TVSeriesPreviewMapper.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SearchApplication

/// Maps a context ``TVSeriesPreviewDetails`` to the feature's ``TVSeriesPreview`` presentation model.
public struct TVSeriesPreviewMapper {

    /// Creates a TV-series-preview mapper.
    public init() {}

    /// Maps a context ``TVSeriesPreviewDetails`` to a presentation ``TVSeriesPreview``.
    public func map(_ tvSeriesPreviewDetails: TVSeriesPreviewDetails) -> TVSeriesPreview {
        TVSeriesPreview(
            id: tvSeriesPreviewDetails.id,
            name: tvSeriesPreviewDetails.name,
            posterURL: tvSeriesPreviewDetails.posterURLSet?.thumbnail
        )
    }

}
