//
//  Credits.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// Represents ``Credits``.
public struct Credits: Identifiable, Equatable, Sendable {

    /// The ``id`` value.
    public let id: Int
    /// The ``cast`` value.
    public let cast: [CastMember]
    /// The ``crew`` value.
    public let crew: [CrewMember]

    /// Creates a new instance.
    public init(
        id: Int,
        cast: [CastMember],
        crew: [CrewMember]
    ) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
