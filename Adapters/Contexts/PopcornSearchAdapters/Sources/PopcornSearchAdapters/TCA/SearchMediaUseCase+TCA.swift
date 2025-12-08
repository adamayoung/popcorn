//
//  SearchMediaUseCase+TCA.swift
//  PopcornSearchAdapters
//
//  Created by Adam Young on 18/11/2025.
//

import ComposableArchitecture
import Foundation
import SearchApplication

enum SearchMediaUseCaseKey: DependencyKey {

    static var liveValue: any SearchMediaUseCase {
        DependencyValues._current
            .searchFactory
            .makeSearchMediaUseCase()
    }

}

extension DependencyValues {

    public var searchMedia: any SearchMediaUseCase {
        get { self[SearchMediaUseCaseKey.self] }
        set { self[SearchMediaUseCaseKey.self] = newValue }
    }

}
