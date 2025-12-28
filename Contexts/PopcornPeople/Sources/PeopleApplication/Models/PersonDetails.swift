//
//  PersonDetails.swift
//  PopcornPeople
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// A presentation model containing detailed information about a person.
///
/// This model includes biographical data and fully-resolved profile image URLs,
/// making it suitable for direct use in UI layers.
///
public struct PersonDetails: Identifiable, Equatable, Sendable {

    /// The unique identifier for the person.
    public let id: Int

    /// The person's full name.
    public let name: String

    /// A biographical description of the person.
    public let biography: String

    /// The department or role the person is primarily known for (e.g., "Acting", "Directing").
    public let knownForDepartment: String

    /// The person's gender.
    public let gender: Gender

    /// A set of profile image URLs at various resolutions.
    public let profileURLSet: ImageURLSet?

    ///
    /// Creates a new person details instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the person.
    ///   - name: The person's full name.
    ///   - biography: A biographical description.
    ///   - knownForDepartment: The department or role they're known for.
    ///   - gender: The person's gender.
    ///   - profileURLSet: A set of profile image URLs. Defaults to `nil`.
    ///
    public init(
        id: Int,
        name: String,
        biography: String,
        knownForDepartment: String,
        gender: Gender,
        profileURLSet: ImageURLSet? = nil
    ) {
        self.id = id
        self.name = name
        self.biography = biography
        self.knownForDepartment = knownForDepartment
        self.gender = gender
        self.profileURLSet = profileURLSet
    }

}
