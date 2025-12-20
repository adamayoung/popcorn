//
//  PersonSearchHistoryEntryMapper.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SearchDomain

struct PersonSearchHistoryEntryMapper {

    func map(_ entity: SearchMediaSearchHistoryEntryEntity) -> PersonSearchHistoryEntry? {
        guard
            entity.mediaType == .person,
            let id = entity.mediaID,
            let timestamp = entity.timestamp
        else {
            return nil
        }

        return PersonSearchHistoryEntry(id: id, timestamp: timestamp)
    }

}
