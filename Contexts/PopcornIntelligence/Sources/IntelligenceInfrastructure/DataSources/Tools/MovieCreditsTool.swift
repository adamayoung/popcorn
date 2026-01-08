//
//  MovieCreditsTool.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import FoundationModels
import IntelligenceDomain

final class MovieCreditsTool: Tool {

    private let creditsProvider: any CreditsProviding

    let name = "fetchMovieCredits"
    let description = "Fetch the top listed credits (cast and crew) of a movie."

    init(creditsProvider: some CreditsProviding) {
        self.creditsProvider = creditsProvider
    }

    @Generable
    struct Arguments {
        @Guide(description: "This is the ID of the movie of the credits to fetch.")
        let movieID: Int
    }

    @Generable
    struct Credits: PromptRepresentable {
        @Guide(description: "This is the ID of the movie.")
        let id: Int
        @Guide(description: "This is the list of top cast members of the movie.")
        let cast: [CastMember]
        @Guide(description: "This is the list of top crew members of the movie.")
        let crew: [CrewMember]
    }

    @Generable
    struct CastMember: PromptRepresentable {
        @Guide(description: "This is the ID of the cast member in a particular movie.")
        let id: String
        @Guide(description: "This is the ID of the person for this cast member.")
        let personID: Int
        @Guide(description: "This is the cast member's real name.")
        let personName: String
        @Guide(description: "This is the cast member's character name in the movie.")
        let characterName: String
    }

    @Generable
    struct CrewMember: PromptRepresentable {
        @Guide(description: "This is the ID of the crew member in a particular movie.")
        let id: String
        @Guide(description: "This is the ID of the person for this crew member.")
        let personID: Int
        @Guide(description: "This is the crew member's real name.")
        let personName: String
        @Guide(description: "This is the crew member's job in the movie.")
        let job: String
    }

    func call(arguments: MovieCreditsTool.Arguments) async throws -> Credits {
        let credits = try await creditsProvider.credits(forMovie: arguments.movieID)
        let mapper = MovieCreditsToolMapper()
        return mapper.map(credits, limit: 10)
    }

}
