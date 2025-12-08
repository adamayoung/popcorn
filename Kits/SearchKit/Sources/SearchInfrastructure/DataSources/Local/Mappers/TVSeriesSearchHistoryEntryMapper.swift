//
//  TVSeriesSearchHistoryEntryMapper.swift
//  SearchKit
//
//  Created by Adam Young on 04/12/2025.
//

import Foundation
import SearchDomain

struct TVSeriesSearchHistoryEntryMapper {

    func map(_ entity: MediaSearchHistoryEntryEntity) -> TVSeriesSearchHistoryEntry? {
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
