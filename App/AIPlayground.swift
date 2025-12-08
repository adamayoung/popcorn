//
//  AIPlayground.swift
//  Popcorn
//
//  Created by Adam Young on 04/12/2025.
//

import Foundation
import FoundationModels
import Playgrounds

@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
#Playground {

    let session = LanguageModelSession(
        instructions: """
                You rewrite film summaries as sarcastic, deadpan commentaries with sharp humor.
                Keep core plot beats, no names, no explicit titles.
                Do not write unsafe content.
            """
    )

    let toyStorySynopsis = """
            Toy Story

            Led by Woody, Andy's toys live happily in his room until Andy's birthday brings Buzz Lightyear onto the scene. Afraid of losing his place in Andy's heart, Woody plots against Buzz. But when circumstances separate Buzz and Woody from their owner, the duo eventually learns to put aside their differences.
        """

    let theDarkKnightSynopsis = """
            The Dark Knight

            Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations that plague the streets. The partnership proves to be effective, but they soon find themselves prey to a reign of chaos unleashed by a rising criminal mastermind known to the terrified citizens of Gotham as the Joker.
        """

    let response = try await session.respond(
        to: "Rewrite the following into a cryptic, ominous synopsis:\n\n\(toyStorySynopsis)"
    )

    let response2 = try await session.respond(
        to: "Rewrite the following into a cryptic, ominous synopsis:\n\n\(theDarkKnightSynopsis)"
    )

    print(response2.content.description)

}
