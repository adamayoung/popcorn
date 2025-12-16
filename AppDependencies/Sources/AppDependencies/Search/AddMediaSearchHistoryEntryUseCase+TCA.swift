//
//  AddMediaSearchHistoryEntryUseCase+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 04/12/2025.
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

extension DependencyValues {

    public var addMediaSearchHistoryEntry: any AddMediaSearchHistoryEntryUseCase {
        get { self[AddMediaSearchHistoryEntryUseCaseKey.self] }
        set { self[AddMediaSearchHistoryEntryUseCaseKey.self] = newValue }
    }

}
