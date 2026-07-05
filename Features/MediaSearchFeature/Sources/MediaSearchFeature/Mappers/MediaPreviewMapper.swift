//
//  MediaPreviewMapper.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SearchApplication

/// Maps a context ``MediaPreviewDetails`` to the feature's ``MediaPreview`` presentation model.
public struct MediaPreviewMapper {

    /// Creates a media-preview mapper.
    public init() {}

    /// Maps a context ``MediaPreviewDetails`` to a presentation ``MediaPreview``.
    public func map(_ mediaPreviewDetails: MediaPreviewDetails) -> MediaPreview {
        switch mediaPreviewDetails {
        case .movie(let moviePreviewDetails):
            let mapper = MoviePreviewMapper()
            return .movie(mapper.map(moviePreviewDetails))
        case .tvSeries(let tvSeriesPreviewDetails):
            let mapper = TVSeriesPreviewMapper()
            return .tvSeries(mapper.map(tvSeriesPreviewDetails))
        case .person(let personPreviewDetails):
            let mapper = PersonPreviewMapper()
            return .person(mapper.map(personPreviewDetails))
        }
    }

}
