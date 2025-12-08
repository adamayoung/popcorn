//
//  PeopleApplicationFactory+TCA.swift
//  PopcornPeopleAdapters
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import Foundation
import PeopleApplication
import PopcornConfigurationAdapters
import TMDbAdapters

extension DependencyValues {

    var peopleFactory: PeopleApplicationFactory {
        PopcornPeopleAdaptersFactory(
            personService: self.personService,
            fetchAppConfigurationUseCase: self.fetchAppConfiguration
        ).makePeopleFactory()
    }

}
