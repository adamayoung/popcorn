//
//  PersonPreviewDetails.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// A detailed person preview model for presentation in the UI.
///
/// This model extends the basic person preview with resolved image URL sets
/// at various resolutions, suitable for direct use in views.
///
public struct PersonPreviewDetails: Identifiable, Equatable, Sendable {

    /// The unique identifier for the person.
    public let id: Int

    /// The person's full name.
    public let name: String

    /// The department or role the person is primarily known for (e.g., "Acting", "Directing").
    public let knownForDepartment: String?

    /// The person's gender.
    public let gender: Gender

    /// URL set containing profile images at various resolutions.
    public let profileURLSet: ImageURLSet?

    ///
    /// Creates a new person preview details instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the person.
    ///   - name: The person's full name.
    ///   - knownForDepartment: The department or role they're known for. Defaults to `nil`.
    ///   - gender: The person's gender.
    ///   - profileURLSet: URL set for profile images. Defaults to `nil`.
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
