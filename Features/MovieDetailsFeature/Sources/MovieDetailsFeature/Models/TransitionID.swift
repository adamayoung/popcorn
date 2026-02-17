//
//  TransitionID.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

struct TransitionID {

    let itemID: Int
    let context: String?

    init(itemID: Int, context: String? = nil) {
        self.itemID = itemID
        self.context = context
    }

    init(castMember: CastMember) {
        self.init(itemID: castMember.personID, context: "MovieDetails-CastMember")
    }

    init(crewMember: CrewMember) {
        self.init(itemID: crewMember.personID, context: "MovieDetails-CrewMember")
    }

    var value: String {
        if let context {
            return "\(itemID)_\(context)"
        }

        return "\(itemID)"
    }

}
