//
//  PeopleApplicationFactory+TCA.swift
//  PeopleKitAdapters
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import ConfigurationKitAdapters
import Foundation
import PeopleApplication
import TMDbAdapters

extension DependencyValues {

    var peopleFactory: PeopleApplicationFactory {
        PeopleKitAdaptersFactory(
            personService: self.personService,
            fetchAppConfigurationUseCase: self.fetchAppConfiguration
        ).makePeopleFactory()
    }

}
