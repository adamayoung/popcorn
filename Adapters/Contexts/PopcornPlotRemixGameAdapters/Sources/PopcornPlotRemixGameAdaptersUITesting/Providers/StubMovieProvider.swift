//
//  StubMovieProvider.swift
//  PopcornPlotRemixGameAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PlotRemixGameDomain

final class StubMovieProvider: MovieProviding, Sendable {

    func randomMovies(filter: MovieFilter, limit: Int) async throws(MovieProviderError) -> [Movie] {
        Array(Self.movies.prefix(limit))
    }

    func randomSimilarMovies(to movieID: Int, limit: Int) async throws(MovieProviderError) -> [Movie] {
        Array(Self.movies.filter { $0.id != movieID }.prefix(limit))
    }

}

extension StubMovieProvider {

    // MARK: - TMDb Movie Data

    // swiftlint:disable line_length
    static let movies: [Movie] = [
        Movie(
            id: 1_242_898,
            title: "Predator: Badlands",
            overview: "Cast out from his clan, a young Predator finds an unlikely ally in a damaged android and embarks on a treacherous journey in search of the ultimate adversary.",
            posterPath: URL(string: "/pHpq9yNUIo6aDoCXEBzjSolywgz.jpg"),
            backdropPath: URL(string: "/ebyxeBh56QNXxSJgTnmz7fXAlwk.jpg")
        ),
        Movie(
            id: 83533,
            title: "Avatar: Fire and Ash",
            overview: "In the wake of the devastating war against the RDA and the loss of their eldest son, Jake Sully and Neytiri face a new threat on Pandora: the Ash People, a violent and power-hungry Na'vi tribe.",
            posterPath: URL(string: "/cf7hE1ifY4UNbS25tGnaTyyDrI2.jpg"),
            backdropPath: URL(string: "/vm4H1DivjQoNIm0Vs6i3CTzFxQ0.jpg")
        ),
        Movie(
            id: 1_084_242,
            title: "Zootopia 2",
            overview: "After cracking the biggest case in Zootopia's history, rookie cops Judy Hopps and Nick Wilde find themselves on the twisting trail of a great mystery.",
            posterPath: URL(string: "/bjUWGw0Ao0qVWxagN3VCwBJHVo6.jpg"),
            backdropPath: URL(string: "/7nfpkR9XsQ1lBNCXSSHxGV7Dkxe.jpg")
        ),
        Movie(
            id: 533_533,
            title: "TRON: Ares",
            overview: "A highly sophisticated Program called Ares is sent from the digital world into the real world on a dangerous mission, marking humankind's first encounter with A.I. beings.",
            posterPath: URL(string: "/chpWmskl3aKm1aTZqUHRCtviwPy.jpg"),
            backdropPath: URL(string: "/min9ZUDZbiguTiQ7yz1Hbqk78HT.jpg")
        ),
        Movie(
            id: 1_062_722,
            title: "Frankenstein",
            overview: "Dr. Victor Frankenstein, a brilliant but egotistical scientist, brings a creature to life in a monstrous experiment that ultimately leads to the undoing of both the creator and his tragic creation.",
            posterPath: URL(string: "/g4JtvGlQO7DByTI6frUobqvSL3R.jpg"),
            backdropPath: URL(string: "/ceyakefyCRAgyeFhefa2bz6d9QO.jpg")
        )
    ]
    // swiftlint:enable line_length

}
