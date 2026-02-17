//
//  MediaSearchHistoryEntryMapper.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SearchDomain

struct MediaSearchHistoryEntryMapper {

    func map(_ entity: SearchMediaSearchHistoryEntryEntity) -> MediaSearchHistoryEntry? {
        guard let mediaType = entity.mediaType else {
            return nil
        }

        switch mediaType {
        case .movie:
            guard let entry = MovieSearchHistoryEntryMapper().map(entity) else {
                return nil
            }

            return .movie(entry)

        case .tvSeries:
            guard let entry = TVSeriesSearchHistoryEntryMapper().map(entity) else {
                return nil
            }

            return .tvSeries(entry)

        case .person:
            guard let entry = PersonSearchHistoryEntryMapper().map(entity) else {
                return nil
            }

            return .person(entry)
        }
    }

}
