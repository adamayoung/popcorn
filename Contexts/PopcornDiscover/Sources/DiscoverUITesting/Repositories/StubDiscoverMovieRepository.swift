//
//  StubDiscoverMovieRepository.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation

public final class StubDiscoverMovieRepository: DiscoverMovieRepository, Sendable {

    public init() {}

    public func movies(
        filter: MovieFilter?,
        page: Int
    ) async throws(DiscoverMovieRepositoryError) -> [MoviePreview] {
        Self.stubMovies
    }

}

extension StubDiscoverMovieRepository {

    // Movie IDs must match MoviesUITesting.StubMovieRepository for full details to load
    // swiftlint:disable line_length
    private static let stubMovies: [MoviePreview] = [
        MoviePreview(
            id: 1_242_898,
            title: "Predator: Badlands",
            overview: "Cast out from his clan, a young Predator finds an unlikely ally in a damaged android and embarks on a treacherous journey in search of the ultimate adversary.",
            releaseDate: date(year: 2025, month: 11, day: 5),
            genreIDs: [28, 878, 12],
            posterPath: URL(string: "/pHpq9yNUIo6aDoCXEBzjSolywgz.jpg"),
            backdropPath: URL(string: "/ebyxeBh56QNXxSJgTnmz7fXAlwk.jpg")
        ),
        MoviePreview(
            id: 1_252_037,
            title: "The Tank",
            overview: "A German Tiger tank crew is sent on a dangerous mission to rescue the missing officer Paul von Hardenburg from a top-secret bunker behind enemy lines.",
            releaseDate: date(year: 2025, month: 9, day: 18),
            genreIDs: [10752, 28, 18],
            posterPath: URL(string: "/65Jr1JAgWlu9em8zHhAfrNJJQBt.jpg"),
            backdropPath: URL(string: "/vMxOmgmBGegjVObjlb8ugsjGgkD.jpg")
        ),
        MoviePreview(
            id: 83533,
            title: "Avatar: Fire and Ash",
            overview: "In the wake of the devastating war against the RDA and the loss of their eldest son, Jake Sully and Neytiri face a new threat on Pandora: the Ash People.",
            releaseDate: date(year: 2025, month: 12, day: 17),
            genreIDs: [878, 12, 14],
            posterPath: URL(string: "/cf7hE1ifY4UNbS25tGnaTyyDrI2.jpg"),
            backdropPath: URL(string: "/iN41Ccw4DctL8npfmYg1j5Tr1eb.jpg")
        ),
        MoviePreview(
            id: 1_084_242,
            title: "Zootopia 2",
            overview: "After cracking the biggest case in Zootopia's history, rookie cops Judy Hopps and Nick Wilde find themselves on the twisting trail of a great mystery.",
            releaseDate: date(year: 2025, month: 11, day: 26),
            genreIDs: [16, 35, 12, 10751, 9648],
            posterPath: URL(string: "/bjUWGw0Ao0qVWxagN3VCwBJHVo6.jpg"),
            backdropPath: URL(string: "/7nfpkR9XsQ1lBNCXSSHxGV7Dkxe.jpg")
        ),
        MoviePreview(
            id: 628_847,
            title: "Trap House",
            overview: "An undercover DEA agent and his partner embark on a game of cat and mouse with an audacious, and surprising group of thieves.",
            releaseDate: date(year: 2025, month: 11, day: 14),
            genreIDs: [28, 80, 53],
            posterPath: URL(string: "/6tpAPeuuqbVnYWWPoOLEDLSBU7a.jpg"),
            backdropPath: URL(string: "/oIJjO1CvEdTMFNkWfHaV0RB584G.jpg")
        ),
        MoviePreview(
            id: 1_311_031,
            title: "Demon Slayer: Kimetsu no Yaiba Infinity Castle",
            overview: "The Demon Slayer Corps are drawn into the Infinity Castle, where Tanjiro, Nezuko, and the Hashira face terrifying Upper Rank demons.",
            releaseDate: date(year: 2025, month: 7, day: 18),
            genreIDs: [16, 28, 14],
            posterPath: URL(string: "/fWVSwgjpT2D78VUh6X8UBd2rorW.jpg"),
            backdropPath: URL(string: "/1RgPyOhN4DRs225BGTlHJqCudII.jpg")
        ),
        MoviePreview(
            id: 1_368_166,
            title: "The Housemaid",
            overview: "Trying to escape her past, Millie Calloway accepts a job as a live-in housemaid for the wealthy Nina and Andrew Winchester.",
            releaseDate: date(year: 2025, month: 12, day: 18),
            genreIDs: [9648, 53],
            posterPath: URL(string: "/cWsBscZzwu5brg9YjNkGewRUvJX.jpg"),
            backdropPath: URL(string: "/sK3z0Naed3H1Wuh7a21YRVMxYqt.jpg")
        ),
        MoviePreview(
            id: 1_228_246,
            title: "Five Nights at Freddy's 2",
            overview: "One year since the supernatural nightmare at Freddy Fazbear's Pizza, the stories about what transpired there have been twisted into a campy local legend.",
            releaseDate: date(year: 2025, month: 12, day: 3),
            genreIDs: [27, 53],
            posterPath: URL(string: "/udAxQEORq2I5wxI97N2TEqdhzBE.jpg"),
            backdropPath: URL(string: "/mOeBBD49M72vCEXzgA1dS2MwGno.jpg")
        )
    ]
    // swiftlint:enable line_length

    private static func date(year: Int, month: Int, day: Int) -> Date {
        DateComponents(calendar: .current, year: year, month: month, day: day).date ?? .now
    }

}
