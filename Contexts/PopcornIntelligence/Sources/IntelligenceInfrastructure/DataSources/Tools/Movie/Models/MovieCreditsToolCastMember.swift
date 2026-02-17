//
//  MovieCreditsToolCastMember.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import FoundationModels

@Generable
struct MovieCreditsToolCastMember: PromptRepresentable, Equatable {
    @Guide(description: "This is the ID of the cast member in a particular movie.")
    let id: String
    @Guide(description: "This is the ID of the person for this cast member.")
    let personID: Int
    @Guide(description: "This is the cast member's real name.")
    let personName: String
    @Guide(description: "This is the cast member's character name in the movie.")
    let characterName: String
}
