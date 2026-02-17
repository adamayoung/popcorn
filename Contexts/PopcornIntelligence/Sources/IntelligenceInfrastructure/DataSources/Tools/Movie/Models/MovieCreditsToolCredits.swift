//
//  MovieCreditsToolCredits.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import FoundationModels

@Generable
struct MovieCreditsToolCredits: PromptRepresentable, Equatable {
    @Guide(description: "This is the ID of the movie.")
    let id: Int
    @Guide(description: "This is the list of top cast members of the movie.")
    let cast: [MovieCreditsToolCastMember]
    @Guide(description: "This is the list of top crew members of the movie.")
    let crew: [MovieCreditsToolCrewMember]
}
