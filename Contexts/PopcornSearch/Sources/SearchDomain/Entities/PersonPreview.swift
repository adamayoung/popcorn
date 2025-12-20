//
//  PersonPreview.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

public struct PersonPreview: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let knownForDepartment: String?
    public let gender: Gender
    public let profilePath: URL?

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
