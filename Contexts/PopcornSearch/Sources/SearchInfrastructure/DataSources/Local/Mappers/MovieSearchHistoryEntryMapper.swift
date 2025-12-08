//
//  MovieSearchHistoryEntryMapper.swift
//  PopcornSearch
//
//  Created by Adam Young on 04/12/2025.
//

import Foundation
import SearchDomain

struct MovieSearchHistoryEntryMapper {

    func map(_ entity: MediaSearchHistoryEntryEntity) -> MovieSearchHistoryEntry? {
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
