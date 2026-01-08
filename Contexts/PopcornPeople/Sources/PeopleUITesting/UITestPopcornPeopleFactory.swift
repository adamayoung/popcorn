//
//  UITestPopcornPeopleFactory.swift
//  PopcornPeople
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PeopleApplication
import PeopleComposition
import PeopleDomain

public final class UITestPopcornPeopleFactory: PopcornPeopleFactory {

    private let applicationFactory: PeopleApplicationFactory

    public init() {
        self.applicationFactory = PeopleApplicationFactory(
            personRepository: StubPersonRepository(),
            appConfigurationProvider: StubAppConfigurationProvider()
        )
    }

    public func makeFetchPersonDetailsUseCase() -> FetchPersonDetailsUseCase {
        applicationFactory.makeFetchPersonDetailsUseCase()
    }

}
