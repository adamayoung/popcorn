//
//  PersonRepository.swift
//  PopcornPeople
//
//  Created by Adam Young on 18/11/2025.
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
