//
//  Person.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

///
/// Represents a person (actor, director, crew member, etc.) in the domain model.
///
/// A person contains biographical information, their role in the entertainment industry,
/// and associated profile imagery. This is the core domain entity used throughout
/// the people context for representing individuals.
///
public struct Person: Identifiable, Equatable, Sendable {

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

    /// URL path to the person's profile image.
    public let profilePath: URL?

    ///
    /// Creates a new person instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the person.
    ///   - name: The person's full name.
    ///   - biography: A biographical description.
    ///   - knownForDepartment: The department or role they're known for.
    ///   - gender: The person's gender.
    ///   - profilePath: URL path to the profile image. Defaults to `nil`.
    ///
    public init(
        id: Int,
        name: String,
        biography: String,
        knownForDepartment: String,
        gender: Gender,
        profilePath: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.biography = biography
        self.knownForDepartment = knownForDepartment
        self.gender = gender
        self.profilePath = profilePath
    }

}
