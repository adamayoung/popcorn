//
//  FetchMediaSearchHistoryUseCase+TCA.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import SearchApplication

enum FetchMediaSearchHistoryUseCaseKey: DependencyKey {

    static var liveValue: any FetchMediaSearchHistoryUseCase {
        @Dependency(\.searchFactory) var searchFactory
        return searchFactory.makeFetchMediaSearchHistory()
    }

}

public extension DependencyValues {

    var fetchMediaSearchHistory: any FetchMediaSearchHistoryUseCase {
        get { self[FetchMediaSearchHistoryUseCaseKey.self] }
        set { self[FetchMediaSearchHistoryUseCaseKey.self] = newValue }
    }

}
