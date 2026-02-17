//
//  MovieToolGenre.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import FoundationModels

@Generable
struct MovieToolGenre: PromptRepresentable, Equatable {
    @Guide(description: "This is the ID of the genre.")
    let id: Int
    @Guide(description: "This is the name of the genre.")
    let name: String
}
