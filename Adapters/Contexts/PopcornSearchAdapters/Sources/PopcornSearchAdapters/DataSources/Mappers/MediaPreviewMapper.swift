//
//  MediaPreviewMapper.swift
//  PopcornSearchAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SearchDomain
import TMDb

///
/// A mapper that converts TMDb media objects to domain media previews.
///
struct MediaPreviewMapper {

    ///
    /// Maps a TMDb media object to a domain media preview.
    ///
    /// - Parameter dto: The TMDb media data transfer object to map.
    ///
    /// - Returns: A ``MediaPreview`` if the media type is supported, or `nil` otherwise.
    ///
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
