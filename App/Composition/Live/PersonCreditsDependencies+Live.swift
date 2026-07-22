//
//  PersonCreditsDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import PeopleApplication
import PeopleComposition
import PersonCreditsFeature

extension PersonCreditsDependencies {

    /// Builds the production dependencies from the app's shared services.
    static func live(services: AppServices) -> PersonCreditsDependencies {
        let fetchPersonCredits = services.peopleFactory.makeFetchPersonCreditsUseCase()

        return PersonCreditsDependencies(
            fetchCredits: { personID in
                do {
                    let credits = try await fetchPersonCredits.execute(personID: personID)
                    let mapper = CreditItemMapper()
                    return credits.map(mapper.map)
                } catch let error as FetchPersonCreditsError {
                    throw FetchCreditsError(error)
                }
            }
        )
    }

}
