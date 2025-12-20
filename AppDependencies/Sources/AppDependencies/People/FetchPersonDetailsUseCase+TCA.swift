//
//  FetchPersonDetailsUseCase+TCA.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import PeopleApplication

enum FetchPersonDetailsUseCaseKey: DependencyKey {

    static var liveValue: any FetchPersonDetailsUseCase {
        @Dependency(\.peopleFactory) var peopleFactory
        return peopleFactory.makeFetchPersonDetailsUseCase()
    }

}

public extension DependencyValues {

    var fetchPersonDetails: any FetchPersonDetailsUseCase {
        get { self[FetchPersonDetailsUseCaseKey.self] }
        set { self[FetchPersonDetailsUseCaseKey.self] = newValue }
    }

}
