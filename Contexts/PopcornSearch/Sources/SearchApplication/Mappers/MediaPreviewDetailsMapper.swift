//
//  MediaPreviewDetailsMapper.swift
//  PopcornSearch
//
//  Created by Adam Young on 25/11/2025.
//

import CoreDomain
import Foundation
import SearchDomain

struct MediaPreviewDetailsMapper {

    func map(_ mediaPreview: MediaPreview, imagesConfiguration: ImagesConfiguration)
        -> MediaPreviewDetails
    {
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
