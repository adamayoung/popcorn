//
//  SearchMediaSearchHistoryEntryEntity.swift
//  PopcornSearch
//
//  Created by Adam Young on 04/12/2025.
//

import Foundation
import SwiftData

@Model
final class SearchMediaSearchHistoryEntryEntity: Equatable {

    var mediaID: Int?
    var mediaType: MediaType?
    var timestamp: Date?

    init(
        mediaID: Int,
        mediaType: MediaType,
        timestamp: Date
    ) {
        self.mediaID = mediaID
        self.mediaType = mediaType
        self.timestamp = timestamp
    }

}

extension SearchMediaSearchHistoryEntryEntity {

    enum MediaType: String, Codable {
        case movie
        case tvSeries
        case person
    }

}
