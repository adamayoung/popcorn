//
//  PersonPreview.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// Represents a trending person preview.
///
/// This entity contains essential information about a person for displaying in trending lists.
/// It includes basic biographical data like name, gender, and department, along with
/// profile imagery for presentation in trending rankings.
///
public struct PersonPreview: Identifiable, Equatable, Sendable {

    /// The unique identifier for the person.
    public let id: Int

    /// The person's full name.
    public let name: String

    /// The department or role the person is primarily known for (e.g., "Acting", "Directing").
    public let knownForDepartment: String?

    /// The person's gender.
    public let gender: Gender

    /// URL path to the person's profile image.
    public let profilePath: URL?

    ///
    /// Creates a new trending person preview instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the person.
    ///   - name: The person's full name.
    ///   - knownForDepartment: The department or role they're known for. Defaults to `nil`.
    ///   - gender: The person's gender.
    ///   - profilePath: URL path to the profile image. Defaults to `nil`.
    ///
    public init(
        id: Int,
        name: String,
        knownForDepartment: String? = nil,
        gender: Gender,
        profilePath: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.knownForDepartment = knownForDepartment
        self.gender = gender
        self.profilePath = profilePath
    }

}
