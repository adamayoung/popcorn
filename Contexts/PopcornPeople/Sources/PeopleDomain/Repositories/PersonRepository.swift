//
//  PersonRepository.swift
//  PopcornPeople
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol PersonRepository: Sendable {

    func person(withID id: Int) async throws(PersonRepositoryError) -> Person

}

public enum PersonRepositoryError: Error {

    case notFound
    case unauthorised
    case unknown(Error? = nil)

}
