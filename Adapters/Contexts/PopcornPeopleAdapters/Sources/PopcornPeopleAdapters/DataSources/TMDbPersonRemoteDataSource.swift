//
//  TMDbPersonRemoteDataSource.swift
//  PopcornPeopleAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import PeopleDomain
import PeopleInfrastructure
import TMDb

///
/// A remote data source for fetching person data from TMDb.
///
/// This class implements ``PersonRemoteDataSource`` by leveraging the TMDb API
/// to retrieve detailed person information.
///
final class TMDbPersonRemoteDataSource: PersonRemoteDataSource {

    private let personService: any TMDb.PersonService

    ///
    /// Creates a new TMDb person remote data source.
    ///
    /// - Parameter personService: The TMDb service for fetching person data.
    ///
    init(personService: some TMDb.PersonService) {
        self.personService = personService
    }

    ///
    /// Fetches person details from TMDb.
    ///
    /// - Parameter id: The unique identifier of the person to fetch.
    ///
    /// - Returns: The person domain object with full details.
    ///
    /// - Throws: ``PersonRepositoryError`` if the fetch operation fails.
    ///
    func person(withID id: Int) async throws(PersonRepositoryError) -> PeopleDomain.Person {
        let tmdbPerson: TMDb.Person
        do {
            tmdbPerson = try await personService.details(forPerson: id, language: "en")
        } catch let error {
            throw PersonRepositoryError(error)
        }

        let mapper = PersonMapper()
        let movie = mapper.map(tmdbPerson)

        return movie
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
