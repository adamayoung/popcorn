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

}
