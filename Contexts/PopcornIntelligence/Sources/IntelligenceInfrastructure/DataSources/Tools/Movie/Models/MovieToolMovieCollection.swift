//
//  MovieToolMovieCollection.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import FoundationModels

@Generable
struct MovieToolMovieCollection: PromptRepresentable, Equatable {
    @Guide(description: "This is the ID of the movie collection.")
    let id: Int
    @Guide(description: "This is the name of the movie collection.")
    let name: String
}
