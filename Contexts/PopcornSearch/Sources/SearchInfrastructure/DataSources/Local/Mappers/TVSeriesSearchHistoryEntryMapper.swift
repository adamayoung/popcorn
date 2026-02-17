//
//  TVSeriesSearchHistoryEntryMapper.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SearchDomain

struct TVSeriesSearchHistoryEntryMapper {

    func map(_ entity: SearchMediaSearchHistoryEntryEntity) -> TVSeriesSearchHistoryEntry? {
        guard
            entity.mediaType == .tvSeries,
            let id = entity.mediaID,
            let timestamp = entity.timestamp
        else {
            return nil
        }

        return TVSeriesSearchHistoryEntry(id: id, timestamp: timestamp)
    }

}
