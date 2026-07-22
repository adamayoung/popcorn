//
//  MockPersonRepository.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PeopleDomain

final class MockPersonRepository: PersonRepository, @unchecked Sendable {

    var personCallCount = 0
    var personCalledWith: [Int] = []
    var personStub: Result<Person, PersonRepositoryError>?

    var combinedCreditsCallCount = 0
    var combinedCreditsCalledWith: [Int] = []
    var combinedCreditsStub: Result<[PersonCredit], PersonRepositoryError>?

    func person(withID id: Int) async throws(PersonRepositoryError) -> Person {
        personCallCount += 1
        personCalledWith.append(id)

        guard let stub = personStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let person):
            return person
        case .failure(let error):
            throw error
        }
    }

    func combinedCredits(forPerson id: Int) async throws(PersonRepositoryError) -> [PersonCredit] {
        combinedCreditsCallCount += 1
        combinedCreditsCalledWith.append(id)

        guard let stub = combinedCreditsStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let credits):
            return credits
        case .failure(let error):
            throw error
        }
    }

}
