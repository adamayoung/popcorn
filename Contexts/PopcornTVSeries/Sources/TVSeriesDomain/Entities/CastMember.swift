//
//  CastMember.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

///
/// Represents a cast member in a TV series.
///
/// A cast member contains information about an actor who appeared in a TV series,
/// including their character name, display order, and optional profile image.
///
public struct CastMember: Identifiable, Equatable, Sendable {

    /// The unique identifier for this cast credit entry.
    public let id: String

    /// The unique identifier of the person.
    public let personID: Int

    /// The name of the character portrayed in the TV series.
    public let characterName: String

    /// The person's display name.
    public let personName: String

    /// URL path to the person's profile image, if available.
    public let profilePath: URL?

    /// The person's gender.
    public let gender: Gender

    /// The display order of this cast member in the credits list.
    public let order: Int

    ///
    /// Creates a new cast member instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this cast credit entry.
    ///   - personID: The unique identifier of the person.
    ///   - characterName: The name of the character portrayed.
    ///   - personName: The person's display name.
    ///   - profilePath: URL path to the person's profile image. Defaults to `nil`.
    ///   - gender: The person's gender.
    ///   - order: The display order in the credits list.
    ///
    public init(
        id: String,
        personID: Int,
        characterName: String,
        personName: String,
        profilePath: URL? = nil,
        gender: Gender,
        order: Int
    ) {
        self.id = id
        self.personID = personID
        self.characterName = characterName
        self.personName = personName
        self.profilePath = profilePath
        self.gender = gender
        self.order = order
    }

}
