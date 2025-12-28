//
//  PersonLocalDataSource.swift
//  PopcornPeople
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for local storage of person data.
///
/// Implementations of this protocol provide caching capabilities for person
/// entities, enabling offline access and reducing network requests.
///
public protocol PersonLocalDataSource: Sendable, Actor {

    ///
    /// Retrieves a person from local storage.
    ///
    /// - Parameter id: The unique identifier of the person to retrieve.
    /// - Returns: The cached ``Person`` if available, or `nil` if not found.
    ///
    func person(withID id: Int) async -> Person?

    ///
    /// Stores a person in local storage.
    ///
    /// - Parameter person: The person entity to cache.
    ///
    func setPerson(_ person: Person) async

}
