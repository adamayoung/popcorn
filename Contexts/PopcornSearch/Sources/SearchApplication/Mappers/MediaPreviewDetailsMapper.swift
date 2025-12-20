//
//  MediaPreviewDetailsMapper.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import SearchDomain

struct MediaPreviewDetailsMapper {

    func map(_ mediaPreview: MediaPreview, imagesConfiguration: ImagesConfiguration)
    -> MediaPreviewDetails {
        switch mediaPreview {
        case .movie(let moviePreview):
            let mapper = MoviePreviewDetailsMapper()
            return .movie(mapper.map(moviePreview, imagesConfiguration: imagesConfiguration))

        case .tvSeries(let tvSeriesPreview):
            let mapper = TVSeriesPreviewDetailsMapper()
            return .tvSeries(mapper.map(tvSeriesPreview, imagesConfiguration: imagesConfiguration))

        case .person(let personPreview):
            let mapper = PersonPreviewDetailsMapper()
            return .person(mapper.map(personPreview, imagesConfiguration: imagesConfiguration))
        }
    }

}
