//
//  StubPopularMovieRepository.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

public final class StubPopularMovieRepository: PopularMovieRepository, Sendable {

    public init() {}

    public func popular(page: Int) async throws(PopularMovieRepositoryError) -> [MoviePreview] {
        Self.popularMovies
    }

    public func popularStream() async -> AsyncThrowingStream<[MoviePreview]?, Error> {
        AsyncThrowingStream { continuation in
            continuation.yield(Self.popularMovies)
            continuation.finish()
        }
    }

    public func nextPopularStreamPage() async throws(PopularMovieRepositoryError) {
        // No-op for stub
    }

}

extension StubPopularMovieRepository {

    // MARK: - Popular Movies (Different from Trending/Discover)

    // swiftlint:disable line_length
    static let popularMovies: [MoviePreview] = [
        // Predator: Badlands
        MoviePreview(
            id: 1_242_898,
            title: "Predator: Badlands",
            overview: "Cast out from his clan, a young Predator finds an unlikely ally in a damaged android and embarks on a treacherous journey in search of the ultimate adversary.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 11, day: 5).date,
            posterPath: URL(string: "/pHpq9yNUIo6aDoCXEBzjSolywgz.jpg"),
            backdropPath: URL(string: "/ebyxeBh56QNXxSJgTnmz7fXAlwk.jpg")
        ),
        // The Tank
        MoviePreview(
            id: 1_252_037,
            title: "The Tank",
            overview: "A German Tiger tank crew is sent on a dangerous mission to rescue the missing officer Paul von Hardenburg from a top-secret bunker behind enemy lines.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 9, day: 18).date,
            posterPath: URL(string: "/65Jr1JAgWlu9em8zHhAfrNJJQBt.jpg"),
            backdropPath: URL(string: "/vMxOmgmBGegjVObjlb8ugsjGgkD.jpg")
        ),
        // Avatar: Fire and Ash
        MoviePreview(
            id: 83533,
            title: "Avatar: Fire and Ash",
            overview: "In the wake of the devastating war against the RDA and the loss of their eldest son, Jake Sully and Neytiri face a new threat on Pandora.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 12, day: 17).date,
            posterPath: URL(string: "/cf7hE1ifY4UNbS25tGnaTyyDrI2.jpg"),
            backdropPath: URL(string: "/iN41Ccw4DctL8npfmYg1j5Tr1eb.jpg")
        ),
        // Zootopia 2
        MoviePreview(
            id: 1_084_242,
            title: "Zootopia 2",
            overview: "After cracking the biggest case in Zootopia's history, rookie cops Judy Hopps and Nick Wilde find themselves on the twisting trail of a great mystery.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 11, day: 26).date,
            posterPath: URL(string: "/bjUWGw0Ao0qVWxagN3VCwBJHVo6.jpg"),
            backdropPath: URL(string: "/7nfpkR9XsQ1lBNCXSSHxGV7Dkxe.jpg")
        ),
        // Trap House
        MoviePreview(
            id: 628_847,
            title: "Trap House",
            overview: "An undercover DEA agent and his partner embark on a game of cat and mouse with an audacious group of thieves - their own rebellious teenagers.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 11, day: 14).date,
            posterPath: URL(string: "/6tpAPeuuqbVnYWWPoOLEDLSBU7a.jpg"),
            backdropPath: URL(string: "/oIJjO1CvEdTMFNkWfHaV0RB584G.jpg")
        ),
        // Demon Slayer: Infinity Castle
        MoviePreview(
            id: 1_311_031,
            title: "Demon Slayer: Kimetsu no Yaiba Infinity Castle",
            overview: "The Demon Slayer Corps are drawn into the Infinity Castle, where Tanjiro, Nezuko, and the Hashira face terrifying Upper Rank demons.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 7, day: 18).date,
            posterPath: URL(string: "/fWVSwgjpT2D78VUh6X8UBd2rorW.jpg"),
            backdropPath: URL(string: "/1RgPyOhN4DRs225BGTlHJqCudII.jpg")
        ),
        // The Housemaid
        MoviePreview(
            id: 1_368_166,
            title: "The Housemaid",
            overview: "Trying to escape her past, Millie Calloway accepts a job as a live-in housemaid for the wealthy Winchester family.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 12, day: 18).date,
            posterPath: URL(string: "/cWsBscZzwu5brg9YjNkGewRUvJX.jpg"),
            backdropPath: URL(string: "/sK3z0Naed3H1Wuh7a21YRVMxYqt.jpg")
        ),
        // Five Nights at Freddy's 2
        MoviePreview(
            id: 1_228_246,
            title: "Five Nights at Freddy's 2",
            overview: "One year since the supernatural nightmare at Freddy Fazbear's Pizza, the stories about what transpired there have been twisted into a campy local legend.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 12, day: 3).date,
            posterPath: URL(string: "/udAxQEORq2I5wxI97N2TEqdhzBE.jpg"),
            backdropPath: URL(string: "/mOeBBD49M72vCEXzgA1dS2MwGno.jpg")
        )
    ]
    // swiftlint:enable line_length

}
