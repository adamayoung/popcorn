//
//  MediaPreviewMapper.swift
//  SearchKitAdapters
//
//  Created by Adam Young on 25/11/2025.
//

import Foundation
import SearchDomain
import TMDb

struct MediaPreviewMapper {

    func map(_ dto: Media) -> MediaPreview? {
        switch dto {
        case .movie(let movieDTO):
            let mapper = MoviePreviewMapper()
            return .movie(mapper.map(movieDTO))

        case .tvSeries(let tvSeriesDTO):
            let mapper = TVSeriesPreviewMapper()
            return .tvSeries(mapper.map(tvSeriesDTO))

        case .person(let personDTO):
            let mapper = PersonPreviewMapper()
            return .person(mapper.map(personDTO))

        default:
            return nil
        }
    }

}
