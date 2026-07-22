//
//  FetchPersonCreditsUseCase.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PeopleDomain

///
/// Fetches every movie and TV series a person is credited on.
///
public protocol FetchPersonCreditsUseCase: Sendable {

    ///
    /// Returns a person's full movie and TV series credits, merged per title and
    /// sorted newest first, with undated (typically upcoming) titles leading.
    ///
    /// - Parameter personID: The identifier of the person.
    /// - Returns: The person's ``PersonCreditItem`` values, newest first.
    /// - Throws: ``FetchPersonCreditsError`` if the credits cannot be fetched.
    ///
    func execute(personID: Person.ID) async throws(FetchPersonCreditsError) -> [PersonCreditItem]

}
