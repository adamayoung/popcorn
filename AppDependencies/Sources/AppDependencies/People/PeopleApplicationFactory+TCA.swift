//
//  PeopleApplicationFactory+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import Foundation
import PeopleComposition
import PopcornPeopleAdapters

extension DependencyValues {

    var peopleFactory: PopcornPeopleFactory {
        PopcornPeopleAdaptersFactory(
            personService: self.personService,
            fetchAppConfigurationUseCase: self.fetchAppConfiguration
        ).makePeopleFactory()
    }

}
