//
//  PersonPreview.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

///
/// Represents a simplified person preview in search results.
///
/// This entity provides essential person information optimized for search result displays,
/// containing only the core details needed for quick browsing and selection. It includes
/// professional classification through the known department field and uses the shared
/// ``Gender`` enum from CoreDomain for consistent gender representation across contexts.
///
public struct PersonPreview: Identifiable, Equatable, Sendable {

    /// The unique identifier for the person.
    public let id: Int

    /// The person's name.
    public let name: String

    /// The department the person is primarily known for (e.g., "Acting", "Directing").
    public let knownForDepartment: String?

    /// The person's gender.
    public let gender: Gender

    /// URL path to the person's profile image.
    public let profilePath: URL?

    /// The person's initials derived from their name.
    public let initials: String?

    ///
    /// Creates a new person preview instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the person.
    ///   - name: The person's name.
    ///   - knownForDepartment: The department the person is primarily known for. Defaults to `nil`.
    ///   - gender: The person's gender.
    ///   - profilePath: URL path to the profile image. Defaults to `nil`.
    ///   - initials: The person's initials. Defaults to `nil`.
    ///
    public init(
        id: Int,
        name: String,
        knownForDepartment: String? = nil,
        gender: Gender,
        profilePath: URL? = nil,
        initials: String? = nil
    ) {
        self.id = id
        self.name = name
        self.knownForDepartment = knownForDepartment
        self.gender = gender
        self.profilePath = profilePath
        self.initials = initials
    }

}
