//
//  PersonPreviewDetails.swift
//  SearchKit
//
//  Created by Adam Young on 20/11/2025.
//

import CoreDomain
import Foundation

public struct PersonPreviewDetails: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let knownForDepartment: String?
    public let gender: Gender
    public let profileURLSet: ImageURLSet?

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
