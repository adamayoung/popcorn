//
//  FetchPersonDetailsUseCase.swift
//  PopcornPeople
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PeopleDomain

///
/// Defines the contract for fetching detailed person information.
///
/// Implementations retrieve person data and transform it into a presentation-ready
/// model with fully-resolved image URLs.
///
public protocol FetchPersonDetailsUseCase: Sendable {

    ///
    /// Fetches detailed information for a specific person.
    ///
    /// - Parameter id: The unique identifier of the person to fetch.
    /// - Returns: A ``PersonDetails`` instance containing biographical and image data.
    /// - Throws: ``FetchPersonDetailsError`` if the person cannot be fetched.
    ///
    func execute(id: Person.ID) async throws(FetchPersonDetailsError) -> PersonDetails

}
