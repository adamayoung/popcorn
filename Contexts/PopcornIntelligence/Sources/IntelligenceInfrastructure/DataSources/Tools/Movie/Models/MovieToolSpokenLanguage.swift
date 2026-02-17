//
//  MovieToolSpokenLanguage.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import FoundationModels

@Generable
struct MovieToolSpokenLanguage: PromptRepresentable, Equatable {
    @Guide(description: "This is the language code.")
    let languageCode: String
    @Guide(description: "This is the language name.")
    let name: String
}
