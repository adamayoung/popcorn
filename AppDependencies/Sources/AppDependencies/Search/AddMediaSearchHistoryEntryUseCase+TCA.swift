//
//  AddMediaSearchHistoryEntryUseCase+TCA.swift
//  Popcorn
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

    var addMediaSearchHistoryEntry: any AddMediaSearchHistoryEntryUseCase {
        get { self[AddMediaSearchHistoryEntryUseCaseKey.self] }
        set { self[AddMediaSearchHistoryEntryUseCaseKey.self] = newValue }
    }

}
