//
//  PersonDetails.swift
//  PopcornPeople
//
//  Created by Adam Young on 28/05/2025.
//

import CoreDomain
import Foundation

public struct PersonDetails: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let biography: String
    public let knownForDepartment: String
    public let gender: Gender
    public let profileURLSet: ImageURLSet?

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
