//
//  MediaPreviewMapper.swift
//  MediaSearchFeature
//
//  Created by Adam Young on 25/11/2025.
//

import Foundation
import SearchApplication

struct MediaPreviewMapper {

    func map(_ mediaPreviewDetails: MediaPreviewDetails) -> MediaPreview {
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
