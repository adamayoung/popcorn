//
//  PersonRemoteDataSource.swift
//  PopcornPeople
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for fetching person data from a remote source.
///
/// Implementations of this protocol communicate with external APIs to retrieve
/// person information such as biographical details and profile images.
///
public protocol PersonRemoteDataSource: Sendable {

    ///
    /// Fetches a person from the remote data source.
    ///
    /// - Parameter id: The unique identifier of the person to fetch.
    /// - Returns: The ``Person`` entity retrieved from the remote source.
    /// - Throws: ``PersonRepositoryError`` if the fetch operation fails.
    ///
    func person(withID id: Int) async throws(PersonRepositoryError) -> Person

}
