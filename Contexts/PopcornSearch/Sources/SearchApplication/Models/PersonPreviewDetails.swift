//
//  PersonPreviewDetails.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// Represents detailed person preview information for UI display.
///
/// This model extends the basic person preview with fully resolved image URL sets
/// at multiple resolutions, suitable for displaying person cards and details in the UI.
///
public struct PersonPreviewDetails: Identifiable, Equatable, Sendable {

    /// The unique identifier for the person.
    public let id: Int

    /// The person's name.
    public let name: String

    /// The department the person is primarily known for (e.g., "Acting", "Directing").
    public let knownForDepartment: String?

    /// The person's gender.
    public let gender: Gender

    /// URL set for the person's profile image at various resolutions.
    public let profileURLSet: ImageURLSet?

    ///
    /// Creates a new person preview details instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the person.
    ///   - name: The person's name.
    ///   - knownForDepartment: The department the person is primarily known for. Defaults to `nil`.
    ///   - gender: The person's gender.
    ///   - profileURLSet: URL set for the profile image. Defaults to `nil`.
    ///
    public init(
        id: Int,
        name: String,
        knownForDepartment: String? = nil,
        gender: Gender,
        profileURLSet: ImageURLSet? = nil
    ) {
        self.id = id
        self.name = name
        self.knownForDepartment = knownForDepartment
        self.gender = gender
        self.profileURLSet = profileURLSet
    }

}
