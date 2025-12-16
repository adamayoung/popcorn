//
//  FetchPersonDetailsUseCase+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 19/11/2025.
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

extension DependencyValues {

    public var fetchPersonDetails: any FetchPersonDetailsUseCase {
        get { self[FetchPersonDetailsUseCaseKey.self] }
        set { self[FetchPersonDetailsUseCaseKey.self] = newValue }
    }

}
