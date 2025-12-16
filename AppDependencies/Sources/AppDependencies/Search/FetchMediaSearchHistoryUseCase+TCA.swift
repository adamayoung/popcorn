//
//  FetchMediaSearchHistoryUseCaseKey+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 04/12/2025.
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

extension DependencyValues {

    public var fetchMediaSearchHistory: any FetchMediaSearchHistoryUseCase {
        get { self[FetchMediaSearchHistoryUseCaseKey.self] }
        set { self[FetchMediaSearchHistoryUseCaseKey.self] = newValue }
    }

}
