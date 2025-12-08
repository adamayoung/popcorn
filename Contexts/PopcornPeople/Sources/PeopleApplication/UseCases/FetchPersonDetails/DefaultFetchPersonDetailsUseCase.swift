//
//  DefaultFetchPersonDetailsUseCase.swift
//  PopcornPeople
//
//  Created by Adam Young on 03/06/2025.
//

import CoreDomain
import Foundation
import PeopleDomain

final class DefaultFetchPersonDetailsUseCase: FetchPersonDetailsUseCase {

    private let repository: any PersonRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        repository: some PersonRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.repository = repository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func execute(id: Person.ID) async throws(FetchPersonDetailsError) -> PersonDetails {
        let person: Person
        let appConfiguration: AppConfiguration
        do {
            (person, appConfiguration) = try await (
                repository.person(withID: id),
                appConfigurationProvider.appConfiguration()
            )
        } catch let error {
            throw FetchPersonDetailsError(error)
        }

        let mapper = PersonDetailsMapper()
        let personDetails = mapper.map(person, imagesConfiguration: appConfiguration.images)

        return personDetails
    }

}
