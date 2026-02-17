//
//  SearchMediaSearchHistoryEntryEntity.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
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
