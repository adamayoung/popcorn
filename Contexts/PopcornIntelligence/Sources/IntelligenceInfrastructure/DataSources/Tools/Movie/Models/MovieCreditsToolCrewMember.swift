//
//  MovieCreditsToolCrewMember.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import FoundationModels

@Generable
struct MovieCreditsToolCrewMember: PromptRepresentable, Equatable {
    @Guide(description: "This is the ID of the crew member in a particular movie.")
    let id: String
    @Guide(description: "This is the ID of the person for this crew member.")
    let personID: Int
    @Guide(description: "This is the crew member's real name.")
    let personName: String
    @Guide(description: "This is the crew member's job in the movie.")
    let job: String
}
