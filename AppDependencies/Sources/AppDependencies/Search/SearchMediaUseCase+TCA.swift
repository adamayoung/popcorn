//
//  SearchMediaUseCase+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 18/11/2025.
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

extension DependencyValues {

    public var searchMedia: any SearchMediaUseCase {
        get { self[SearchMediaUseCaseKey.self] }
        set { self[SearchMediaUseCaseKey.self] = newValue }
    }

}
