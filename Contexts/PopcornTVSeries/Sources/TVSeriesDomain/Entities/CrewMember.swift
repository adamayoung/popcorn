//
//  CrewMember.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

///
/// Represents a crew member in a TV series.
///
/// A crew member contains information about a person who worked behind the scenes
/// on a TV series, including their job title, department, and optional profile image.
///
public struct CrewMember: Identifiable, Equatable, Sendable {

    /// The unique identifier for this crew credit entry.
    public let id: String

    /// The unique identifier of the person.
    public let personID: Int

    /// The person's display name.
    public let personName: String

    /// The job title of the crew member (e.g., "Director", "Writer").
    public let job: String

    /// URL path to the person's profile image, if available.
    public let profilePath: URL?

    /// The person's gender.
    public let gender: Gender

    /// The department the crew member belongs to (e.g., "Directing", "Writing").
    public let department: String

    ///
    /// Creates a new crew member instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this crew credit entry.
    ///   - personID: The unique identifier of the person.
    ///   - personName: The person's display name.
    ///   - job: The job title of the crew member.
    ///   - profilePath: URL path to the person's profile image. Defaults to `nil`.
    ///   - gender: The person's gender.
    ///   - department: The department the crew member belongs to.
    ///
    public init(
        id: String,
        personID: Int,
        personName: String,
        job: String,
        profilePath: URL? = nil,
        gender: Gender,
        department: String
    ) {
        self.id = id
        self.personID = personID
        self.personName = personName
        self.job = job
        self.profilePath = profilePath
        self.gender = gender
        self.department = department
    }

}
