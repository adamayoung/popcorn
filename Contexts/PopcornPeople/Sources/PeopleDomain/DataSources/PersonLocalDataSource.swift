//
//  PersonLocalDataSource.swift
//  PopcornPeople
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol PersonLocalDataSource: Sendable, Actor {

    func person(withID id: Int) async -> Person?

    func setPerson(_ person: Person) async

}
