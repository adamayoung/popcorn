//
//  SearchMediaUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
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

    ///
    /// A use case for searching movies, TV series, and people.
    ///
    /// Performs a multi-type search across the media database and returns
    /// matching results for movies, TV series, and people.
    ///
    var searchMedia: any SearchMediaUseCase {
        get { self[SearchMediaUseCaseKey.self] }
        set { self[SearchMediaUseCaseKey.self] = newValue }
    }

}
