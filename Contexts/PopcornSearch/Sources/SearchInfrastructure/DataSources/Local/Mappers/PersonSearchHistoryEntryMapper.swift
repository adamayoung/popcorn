//
//  PersonSearchHistoryEntryMapper.swift
//  PopcornSearch
//
//  Created by Adam Young on 04/12/2025.
//

import Foundation
import SearchDomain

struct PersonSearchHistoryEntryMapper {

    func map(_ entity: MediaSearchHistoryEntryEntity) -> PersonSearchHistoryEntry? {
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
