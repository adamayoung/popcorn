//
//  StubMovieRepository.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

public final class StubMovieRepository: MovieRepository, Sendable {

    public init() {}

    public func movie(withID id: Int) async throws(MovieRepositoryError) -> Movie {
        guard let movie = Self.movies[id] else {
            throw .notFound
        }
        return movie
    }

    public func movieStream(withID id: Int) async -> AsyncThrowingStream<Movie?, Error> {
        AsyncThrowingStream { continuation in
            if let movie = Self.movies[id] {
                continuation.yield(movie)
            }
            continuation.finish()
        }
    }

}

extension StubMovieRepository {

    // MARK: - TMDb Movie Data

    // swiftlint:disable line_length
    static let movies: [Int: Movie] = [
        // Predator: Badlands
        1_242_898: Movie(
            id: 1_242_898,
            title: "Predator: Badlands",
            overview: "Cast out from his clan, a young Predator finds an unlikely ally in a damaged android and embarks on a treacherous journey in search of the ultimate adversary.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 11, day: 5).date,
            posterPath: URL(string: "/pHpq9yNUIo6aDoCXEBzjSolywgz.jpg"),
            backdropPath: URL(string: "/ebyxeBh56QNXxSJgTnmz7fXAlwk.jpg")
        ),
        // Avatar: Fire and Ash
        83533: Movie(
            id: 83533,
            title: "Avatar: Fire and Ash",
            overview: "In the wake of the devastating war against the RDA and the loss of their eldest son, Jake Sully and Neytiri face a new threat on Pandora: the Ash People, a violent and power-hungry Na'vi tribe led by the ruthless Varang.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 12, day: 17).date,
            posterPath: URL(string: "/cf7hE1ifY4UNbS25tGnaTyyDrI2.jpg"),
            backdropPath: URL(string: "/vm4H1DivjQoNIm0Vs6i3CTzFxQ0.jpg")
        ),
        // Zootopia 2
        1_084_242: Movie(
            id: 1_084_242,
            title: "Zootopia 2",
            overview: "After cracking the biggest case in Zootopia's history, rookie cops Judy Hopps and Nick Wilde find themselves on the twisting trail of a great mystery when Gary De'Snake arrives and turns the animal metropolis upside down.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 11, day: 26).date,
            posterPath: URL(string: "/bjUWGw0Ao0qVWxagN3VCwBJHVo6.jpg"),
            backdropPath: URL(string: "/7nfpkR9XsQ1lBNCXSSHxGV7Dkxe.jpg")
        ),
        // The Tank
        1_252_037: Movie(
            id: 1_252_037,
            title: "The Tank",
            overview: "A German Tiger tank crew is sent on a dangerous mission to rescue the missing officer Paul von Hardenburg from a top-secret bunker behind enemy lines.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 9, day: 18).date,
            posterPath: URL(string: "/65Jr1JAgWlu9em8zHhAfrNJJQBt.jpg"),
            backdropPath: URL(string: "/vMxOmgmBGegjVObjlb8ugsjGgkD.jpg")
        ),
        // The Housemaid
        1_368_166: Movie(
            id: 1_368_166,
            title: "The Housemaid",
            overview: "Trying to escape her past, Millie Calloway accepts a job as a live-in housemaid for the wealthy Nina and Andrew Winchester. But what begins as a dream job quickly unravels into something far more dangerous.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 12, day: 18).date,
            posterPath: URL(string: "/cWsBscZzwu5brg9YjNkGewRUvJX.jpg"),
            backdropPath: URL(string: "/sK3z0Naed3H1Wuh7a21YRVMxYqt.jpg")
        ),
        // Five Nights at Freddy's 2
        1_228_246: Movie(
            id: 1_228_246,
            title: "Five Nights at Freddy's 2",
            overview: "One year since the supernatural nightmare at Freddy Fazbear's Pizza, the stories about what transpired there have been twisted into a campy local legend, inspiring the town's first ever Fazfest.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 12, day: 3).date,
            posterPath: URL(string: "/udAxQEORq2I5wxI97N2TEqdhzBE.jpg"),
            backdropPath: URL(string: "/mOeBBD49M72vCEXzgA1dS2MwGno.jpg")
        ),
        // TRON: Ares
        533_533: Movie(
            id: 533_533,
            title: "TRON: Ares",
            overview: "A highly sophisticated Program called Ares is sent from the digital world into the real world on a dangerous mission, marking humankind's first encounter with A.I. beings.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 10, day: 8).date,
            posterPath: URL(string: "/chpWmskl3aKm1aTZqUHRCtviwPy.jpg"),
            backdropPath: URL(string: "/min9ZUDZbiguTiQ7yz1Hbqk78HT.jpg")
        ),
        // Now You See Me: Now You Don't
        425_274: Movie(
            id: 425_274,
            title: "Now You See Me: Now You Don't",
            overview: "The original Four Horsemen reunite with a new generation of illusionists to take on powerful diamond heiress Veronika Vanderberg, who leads a criminal empire built on money laundering and trafficking.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 11, day: 12).date,
            posterPath: URL(string: "/oD3Eey4e4Z259XLm3eD3WGcoJAh.jpg"),
            backdropPath: URL(string: "/dHSz0tSFuO2CsXJ1CApSauP9Ncl.jpg")
        ),
        // Frankenstein
        1_062_722: Movie(
            id: 1_062_722,
            title: "Frankenstein",
            overview: "Dr. Victor Frankenstein, a brilliant but egotistical scientist, brings a creature to life in a monstrous experiment that ultimately leads to the undoing of both the creator and his tragic creation.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 10, day: 17).date,
            posterPath: URL(string: "/g4JtvGlQO7DByTI6frUobqvSL3R.jpg"),
            backdropPath: URL(string: "/ceyakefyCRAgyeFhefa2bz6d9QO.jpg")
        ),
        // Wake Up Dead Man: A Knives Out Mystery
        812_583: Movie(
            id: 812_583,
            title: "Wake Up Dead Man: A Knives Out Mystery",
            overview: "When young priest Jud Duplenticy is sent to assist charismatic firebrand Monsignor Jefferson Wicks, it's clear that all is not well in the pews. After a sudden and seemingly impossible murder rocks the town, the lack of an obvious suspect prompts local police chief Geraldine Scott to join forces with renowned detective Benoit Blanc.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 11, day: 26).date,
            posterPath: URL(string: "/qCOGGi8JBVEZMc3DVby8rUivyXz.jpg"),
            backdropPath: URL(string: "/fiRDzpcJe7qz3yIR43hdXIE3NHv.jpg")
        ),
        // Demon Slayer: Infinity Castle
        1_311_031: Movie(
            id: 1_311_031,
            title: "Demon Slayer: Kimetsu no Yaiba Infinity Castle",
            overview: "The Demon Slayer Corps are drawn into the Infinity Castle, where Tanjiro, Nezuko, and the Hashira face terrifying Upper Rank demons in a desperate fight as the final battle against Muzan Kibutsuji begins.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 7, day: 18).date,
            posterPath: URL(string: "/fWVSwgjpT2D78VUh6X8UBd2rorW.jpg"),
            backdropPath: URL(string: "/1RgPyOhN4DRs225BGTlHJqCudII.jpg")
        ),
        // Trap House
        628_847: Movie(
            id: 628_847,
            title: "Trap House",
            overview: "An undercover DEA agent and his partner embark on a game of cat and mouse with an audacious, and surprising group of thieves - their own rebellious teenagers, who have begun robbing from a dangerous cartel.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 11, day: 14).date,
            posterPath: URL(string: "/6tpAPeuuqbVnYWWPoOLEDLSBU7a.jpg"),
            backdropPath: URL(string: "/oIJjO1CvEdTMFNkWfHaV0RB584G.jpg")
        ),
        // Wicked: For Good
        967_941: Movie(
            id: 967_941,
            title: "Wicked: For Good",
            overview: "As an angry mob rises against the Wicked Witch, Glinda and Elphaba will need to come together one final time. With their singular friendship now the fulcrum of their futures, they will need to truly see each other, with honesty and empathy.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 11, day: 19).date,
            posterPath: URL(string: "/si9tolnefLSUKaqQEGz1bWArOaL.jpg"),
            backdropPath: URL(string: "/l8pwO23MCvqYumzozpxynCNfck1.jpg")
        ),
        // Marty Supreme
        1_317_288: Movie(
            id: 1_317_288,
            title: "Marty Supreme",
            overview: "In 1950s New York, table tennis player Marty Mauser, a young man with a dream no one respects, goes to Hell and back in pursuit of greatness.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 12, day: 19).date,
            posterPath: URL(string: "/firAhZA0uQvRL2slp7v3AnOj0ZX.jpg"),
            backdropPath: URL(string: "/qKWDHofjMHPSEOTLaixkC9ZmjTT.jpg")
        ),
        // One Battle After Another
        1_054_867: Movie(
            id: 1_054_867,
            title: "One Battle After Another",
            overview: "Washed-up revolutionary Bob exists in a state of stoned paranoia, surviving off-grid with his spirited, self-reliant daughter, Willa. When his evil nemesis resurfaces after 16 years and she goes missing, the former radical scrambles to find her.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 9, day: 23).date,
            posterPath: URL(string: "/r4uXvqCeco0KmO0CjlhXuTEFuSE.jpg"),
            backdropPath: URL(string: "/zpEWFNqoN8Qg1SzMMHmaGyOBTdW.jpg")
        ),
        // Anaconda
        1_234_731: Movie(
            id: 1_234_731,
            title: "Anaconda",
            overview: "A group of friends facing mid-life crises head to the rainforest with the intention of remaking their favorite movie from their youth, only to find themselves in a fight for their lives against natural disasters, giant snakes and violent criminals.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 12, day: 24).date,
            posterPath: URL(string: "/5MDnvvkOqthhE5gQebzkcOhD1p5.jpg"),
            backdropPath: URL(string: "/yo41R39airbREp0PYfG30Ofxtgt.jpg")
        )
    ]
    // swiftlint:enable line_length

}
