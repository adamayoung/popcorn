//
//  FetchPersonKnownForUseCase.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PeopleDomain

///
/// Fetches the movies and TV series a person is most known for.
///
public protocol FetchPersonKnownForUseCase: Sendable {

    ///
    /// Returns a person's most relevant movie and TV series credits, ranked and
    /// trimmed for display in a "Known For" carousel.
    ///
    /// - Parameter personID: The identifier of the person.
    /// - Returns: The person's top ``KnownForItem`` values, most relevant first.
    /// - Throws: ``FetchPersonKnownForError`` if the credits cannot be fetched.
    ///
    func execute(personID: Person.ID) async throws(FetchPersonKnownForError) -> [KnownForItem]

}
