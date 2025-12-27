//
//  PersonRepository.swift
//  PopcornPeople
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for accessing and managing person data.
///
/// This repository provides methods to fetch information about people in the
/// entertainment industry (actors, directors, crew members, etc.). Implementations
/// may retrieve data from remote APIs, local caches, or a combination of both.
///
public protocol PersonRepository: Sendable {

    ///
    /// Fetches detailed information for a specific person.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the person to fetch.
    ///   - cachePolicy: The caching strategy to use for this request.
    /// - Returns: A ``Person`` instance containing biographical and career details.
    /// - Throws: ``PersonRepositoryError`` if the person cannot be fetched.
    ///
    func person(
        withID id: Int,
        cachePolicy: CachePolicy
    ) async throws(PersonRepositoryError) -> Person

}

///
/// Errors that can occur when accessing person data through a repository.
///
public extension PersonRepository {

    func person(withID id: Int) async throws(PersonRepositoryError) -> Person {
        try await person(withID: id, cachePolicy: .cacheFirst)
    }

}

public enum PersonRepositoryError: Error {

    /// No cached data is available for the request.
    case cacheUnavailable

    /// The requested person was not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
