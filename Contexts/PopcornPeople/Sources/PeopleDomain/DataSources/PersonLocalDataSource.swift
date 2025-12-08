//
//  PersonLocalDataSource.swift
//  PopcornPeople
//
//  Created by Adam Young on 25/11/2025.
//

import Foundation

public protocol PersonLocalDataSource: Sendable, Actor {

    func person(withID id: Int) async -> Person?

    func setPerson(_ person: Person) async

}
