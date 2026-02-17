//
//  SearchMediaUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import SearchApplication

enum SearchMediaUseCaseKey: DependencyKey {

    static var liveValue: any SearchMediaUseCase {
        @Dependency(\.searchFactory) var searchFactory
        return searchFactory.makeSearchMediaUseCase()
    }

}

public extension DependencyValues {

    var searchMedia: any SearchMediaUseCase {
        get { self[SearchMediaUseCaseKey.self] }
        set { self[SearchMediaUseCaseKey.self] = newValue }
    }

}
