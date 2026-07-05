//
//  PersonDetailsDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import FeatureAccess
import PeopleApplication
import PeopleComposition
import PersonDetailsFeature

extension PersonDetailsDependencies {

    /// Builds the production dependencies from the app's shared services.
    static func live(services: AppServices) -> PersonDetailsDependencies {
        let fetchPersonDetails = services.peopleFactory.makeFetchPersonDetailsUseCase()
        let featureFlags = services.featureFlags

        return PersonDetailsDependencies(
            fetchPerson: { id in
                do {
                    let person = try await fetchPersonDetails.execute(id: id)
                    let mapper = PersonMapper()
                    return mapper.map(person)
                } catch let error as FetchPersonDetailsError {
                    throw FetchPersonError(error)
                }
            },
            // Shares the backdropFocalPoint gate intentionally — focal point
            // alignment is a single feature covering both backdrop and profile images.
            isFocalPointEnabled: {
                featureFlags.isEnabled(.backdropFocalPoint)
            }
        )
    }

}
