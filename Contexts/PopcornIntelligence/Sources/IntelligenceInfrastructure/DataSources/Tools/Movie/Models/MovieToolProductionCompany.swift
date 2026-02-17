//
//  MovieToolProductionCompany.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import FoundationModels

@Generable
struct MovieToolProductionCompany: PromptRepresentable, Equatable {
    @Guide(description: "This is the ID of the production company.")
    let id: Int
    @Guide(description: "This is the name of the production company.")
    let name: String
    @Guide(description: "This is the origin country code of the production company.")
    let originCountry: String
}
