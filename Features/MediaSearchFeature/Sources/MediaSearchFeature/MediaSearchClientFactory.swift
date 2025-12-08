//
//  MediaSearchClientFactory.swift
//  MediaSearchFeature
//
//  Created by Adam Young on 04/12/2025.
//

import ComposableArchitecture
import Foundation
import SearchApplication
import SearchKitAdapters

struct MediaSearchClientFactory {

    @Dependency(\.searchMedia) private var searchMedia: SearchMediaUseCase
    @Dependency(\.fetchMediaSearchHistory) private var fetchMediaSearchHistory:
        FetchMediaSearchHistoryUseCase
    @Dependency(\.addMediaSearchHistoryEntry) private var addMediaSearchHistoryEntry:
        AddMediaSearchHistoryEntryUseCase

    func makeSearchMedia() -> SearchMediaUseCase {
        self.searchMedia
    }

    func makeFetchMediaSearchHistory() -> FetchMediaSearchHistoryUseCase {
        self.fetchMediaSearchHistory
    }

    func makeAddMediaSearchHistoryEntry() -> AddMediaSearchHistoryEntryUseCase {
        self.addMediaSearchHistoryEntry
    }

}
