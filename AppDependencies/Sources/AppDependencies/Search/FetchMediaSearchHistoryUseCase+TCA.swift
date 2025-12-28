//
//  FetchMediaSearchHistoryUseCase+TCA.swift
//  AppDependencies
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

    ///
    /// A use case for fetching the media search history.
    ///
    /// Retrieves recently searched media items to display in search suggestions.
    ///
    var fetchMediaSearchHistory: any FetchMediaSearchHistoryUseCase {
        get { self[FetchMediaSearchHistoryUseCaseKey.self] }
        set { self[FetchMediaSearchHistoryUseCaseKey.self] = newValue }
    }

}
