//
//  MockPersonLocalDataSource.swift
//  PopcornPeople
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PeopleDomain
import PeopleInfrastructure

actor MockPersonLocalDataSource: PersonLocalDataSource {

    var personCallCount = 0
    var personCalledWith: [Int] = []
    nonisolated(unsafe) var personStub: Person?

    func person(withID id: Int) async -> Person? {
        personCallCount += 1
        personCalledWith.append(id)
        return personStub
    }

    var setPersonCallCount = 0
    var setPersonCalledWith: [Person] = []

    func setPerson(_ person: Person) async {
        setPersonCallCount += 1
        setPersonCalledWith.append(person)
    }

}
