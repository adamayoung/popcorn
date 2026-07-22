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
            tmdbPerson = try await personService.details(forPerson: id, language: nil)
        } catch let error {
            throw PersonRepositoryError(error)
        }

        let mapper = PersonMapper()
        return mapper.map(tmdbPerson)
    }

    func combinedCredits(forPerson id: Int) async throws(PersonRepositoryError) -> [PersonCredit] {
        let combinedCredits: TMDb.PersonCombinedCredits
        do {
            combinedCredits = try await personService.combinedCredits(forPerson: id, language: nil)
        } catch let error {
            throw PersonRepositoryError(error)
        }

        let mapper = PersonCreditMapper()
        return mapper.map(combinedCredits)
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
