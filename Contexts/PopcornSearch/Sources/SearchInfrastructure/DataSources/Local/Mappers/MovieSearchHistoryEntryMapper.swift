//
//  MovieSearchHistoryEntryMapper.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SearchDomain

struct MovieSearchHistoryEntryMapper {

    func map(_ entity: SearchMediaSearchHistoryEntryEntity) -> MovieSearchHistoryEntry? {
        guard
            entity.mediaType == .movie,
            let id = entity.mediaID,
            let timestamp = entity.timestamp
        else {
            return nil
        }

        return MovieSearchHistoryEntry(id: id, timestamp: timestamp)
    }

}
