//
//  DefaultFetchPersonDetailsUseCase.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
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
            async let personTask = repository.person(withID: id)
            async let appConfigurationTask = appConfigurationProvider.appConfiguration()
            (person, appConfiguration) = try await (personTask, appConfigurationTask)
        } catch let error {
            throw FetchPersonDetailsError(error)
        }

        let mapper = PersonDetailsMapper()
        return mapper.map(person, imagesConfiguration: appConfiguration.images)
    }

}
