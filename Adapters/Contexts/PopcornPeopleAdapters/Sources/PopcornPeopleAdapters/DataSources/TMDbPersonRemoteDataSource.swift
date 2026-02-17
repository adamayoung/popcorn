//
//  TMDbPersonRemoteDataSource.swift
//  PopcornPeopleAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import PeopleDomain
import PeopleInfrastructure
import TMDb

final class TMDbPersonRemoteDataSource: PersonRemoteDataSource {

    private let personService: any TMDb.PersonService

    init(personService: some TMDb.PersonService) {
        self.personService = personService
    }

    func person(withID id: Int) async throws(PersonRepositoryError) -> PeopleDomain.Person {
        let tmdbPerson: TMDb.Person
        do {
            tmdbPerson = try await personService.details(forPerson: id, language: "en")
        } catch let error {
            throw PersonRepositoryError(error)
        }

        let mapper = PersonMapper()
        return mapper.map(tmdbPerson)
    }

}

private extension PersonRepositoryError {

    init(_ error: Error) {
        guard let error = error as? TMDbError else {
            self = .unknown(error)
            return
        }

        self.init(error)
    }

    init(_ error: TMDbError) {
        switch error {
        case .notFound:
            self = .notFound
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

}
