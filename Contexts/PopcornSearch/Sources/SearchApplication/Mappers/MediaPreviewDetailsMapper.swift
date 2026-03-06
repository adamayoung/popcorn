//
//  MediaPreviewDetailsMapper.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import SearchDomain

struct MediaPreviewDetailsMapper {

    func map(
        _ mediaPreview: MediaPreview,
        imagesConfiguration: ImagesConfiguration,
        themeColor: ThemeColor? = nil
    ) -> MediaPreviewDetails {
        switch mediaPreview {
        case .movie(let moviePreview):
            let mapper = MoviePreviewDetailsMapper()
            return .movie(mapper.map(moviePreview, imagesConfiguration: imagesConfiguration, themeColor: themeColor))

        case .tvSeries(let tvSeriesPreview):
            let mapper = TVSeriesPreviewDetailsMapper()
            return .tvSeries(
                mapper.map(tvSeriesPreview, imagesConfiguration: imagesConfiguration, themeColor: themeColor)
            )

        case .person(let personPreview):
            let mapper = PersonPreviewDetailsMapper()
            return .person(mapper.map(personPreview, imagesConfiguration: imagesConfiguration))
        }
    }

}
