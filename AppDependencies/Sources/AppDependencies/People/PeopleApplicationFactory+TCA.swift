//
//  PeopleApplicationFactory+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import PeopleComposition
import PopcornPeopleAdapters

extension DependencyValues {

    var peopleFactory: PopcornPeopleFactory {
        PopcornPeopleAdaptersFactory(
            personService: personService,
            fetchAppConfigurationUseCase: fetchAppConfiguration
        ).makePeopleFactory()
    }

}
