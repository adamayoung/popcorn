//
//  MovieToolProductionCountry.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import FoundationModels

@Generable
struct MovieToolProductionCountry: PromptRepresentable, Equatable {
    @Guide(description: "This is the country code.")
    let countryCode: String
    @Guide(description: "This is the country name.")
    let name: String
}
