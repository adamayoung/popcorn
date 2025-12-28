//
//  FetchPersonDetailsUseCase+TCA.swift
//  AppDependencies
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

    ///
    /// A use case for fetching detailed information about a specific person.
    ///
    /// Retrieves comprehensive details about a person including biographical
    /// information and profile images.
    ///
    var fetchPersonDetails: any FetchPersonDetailsUseCase {
        get { self[FetchPersonDetailsUseCaseKey.self] }
        set { self[FetchPersonDetailsUseCaseKey.self] = newValue }
    }

}
