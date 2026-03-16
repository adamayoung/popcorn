//
//  WatchProviderDetails.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

public struct WatchProviderDetails: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let logoURLSet: ImageURLSet?

    public init(
        id: Int,
        name: String,
        logoURLSet: ImageURLSet? = nil
    ) {
        self.id = id
        self.name = name
        self.logoURLSet = logoURLSet
    }

}
