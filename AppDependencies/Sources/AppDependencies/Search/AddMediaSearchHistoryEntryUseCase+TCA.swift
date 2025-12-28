//
//  AddMediaSearchHistoryEntryUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import SearchApplication

enum AddMediaSearchHistoryEntryUseCaseKey: DependencyKey {

    static var liveValue: any AddMediaSearchHistoryEntryUseCase {
        @Dependency(\.searchFactory) var searchFactory
        return searchFactory.makeAddMediaSearchHistoryEntryUseCase()
    }

}

public extension DependencyValues {

    ///
    /// A use case for adding a new entry to the media search history.
    ///
    /// Records a media item that the user has selected from search results
    /// to enable recent search functionality.
    ///
    var addMediaSearchHistoryEntry: any AddMediaSearchHistoryEntryUseCase {
        get { self[AddMediaSearchHistoryEntryUseCaseKey.self] }
        set { self[AddMediaSearchHistoryEntryUseCaseKey.self] = newValue }
    }

}
