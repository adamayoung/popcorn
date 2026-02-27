//
//  PersonPreviewDetails.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

public struct PersonPreviewDetails: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let knownForDepartment: String?
    public let gender: Gender
    public let profileURLSet: ImageURLSet?
    public let initials: String?

    public init(
        id: Int,
        name: String,
        knownForDepartment: String? = nil,
        gender: Gender,
        profileURLSet: ImageURLSet? = nil,
        initials: String? = nil
    ) {
        self.id = id
        self.name = name
        self.knownForDepartment = knownForDepartment
        self.gender = gender
        self.profileURLSet = profileURLSet
        self.initials = initials
    }

}
