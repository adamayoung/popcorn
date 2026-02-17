//
//  PeopleApplicationFactory+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import PeopleComposition
import PopcornPeopleAdapters

enum PopcornPeopleFactoryKey: DependencyKey {

    static var liveValue: PopcornPeopleFactory {
        @Dependency(\.personService) var personService
        @Dependency(\.fetchAppConfiguration) var fetchAppConfiguration
        return PopcornPeopleAdaptersFactory(
            personService: personService,
            fetchAppConfigurationUseCase: fetchAppConfiguration
        ).makePeopleFactory()
    }

}

extension DependencyValues {

    var peopleFactory: PopcornPeopleFactory {
        get { self[PopcornPeopleFactoryKey.self] }
        set { self[PopcornPeopleFactoryKey.self] = newValue }
    }

}
