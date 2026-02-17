//
//  StubMovieCreditsRepository.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

public final class StubMovieCreditsRepository: MovieCreditsRepository, Sendable {

    public init() {}

    public func credits(forMovie movieID: Int) async throws(MovieCreditsRepositoryError) -> Credits {
        guard let credits = Self.credits[movieID] else {
            throw .notFound
        }
        return credits
    }

}

extension StubMovieCreditsRepository {

    // MARK: - Credits Data

    static let credits: [Int: Credits] = [
        // Predator: Badlands
        1_242_898: Credits(
            id: 1_242_898,
            cast: [
                CastMember(
                    id: "1242898-18050",
                    personID: 18050,
                    characterName: "Thia / Tessa",
                    personName: "Elle Fanning",
                    profilePath: URL(string: "/e8CUyxQSE99y5IOfzSLtHC0B0Ch.jpg"),
                    gender: .female,
                    order: 0
                ),
                CastMember(
                    id: "1242898-3223391",
                    personID: 3_223_391,
                    characterName: "Dek / Father",
                    personName: "Dimitrius Schuster-Koloamatangi",
                    profilePath: URL(string: "/rmIZTT1AZK3C9fYhEOtGKtSrF8E.jpg"),
                    gender: .male,
                    order: 1
                ),
                CastMember(
                    id: "1242898-1891826",
                    personID: 1_891_826,
                    characterName: "Bud",
                    personName: "Ravi Narayan",
                    profilePath: URL(string: "/iM9dr3AjXTt7IGpRzZlQVG7hINa.jpg"),
                    gender: .male,
                    order: 2
                )
            ],
            crew: [
                CrewMember(
                    id: "1242898-568322-d",
                    personID: 568_322,
                    personName: "Dan Trachtenberg",
                    job: "Director",
                    profilePath: URL(string: "/crABZLMi5SAz7rKm0wV6JUOeKs5.jpg"),
                    gender: .male,
                    department: "Directing"
                ),
                CrewMember(
                    id: "1242898-1061155",
                    personID: 1_061_155,
                    personName: "Patrick Aison",
                    job: "Screenplay",
                    profilePath: nil,
                    gender: .male,
                    department: "Writing"
                ),
                CrewMember(
                    id: "1242898-40825",
                    personID: 40825,
                    personName: "Benjamin Wallfisch",
                    job: "Original Music Composer",
                    profilePath: URL(string: "/dWcshjk0OUi3stGFFrwZIsYKZfQ.jpg"),
                    gender: .male,
                    department: "Sound"
                )
            ]
        ),
        // Zootopia 2 (sample)
        1_084_242: Credits(
            id: 1_084_242,
            cast: [
                CastMember(
                    id: "1084242-417",
                    personID: 417,
                    characterName: "Judy Hopps (voice)",
                    personName: "Ginnifer Goodwin",
                    profilePath: URL(string: "/xOCA2WN5MRfXmJmlzEbFEhIbfIQ.jpg"),
                    gender: .female,
                    order: 0
                ),
                CastMember(
                    id: "1084242-23532",
                    personID: 23532,
                    characterName: "Nick Wilde (voice)",
                    personName: "Jason Bateman",
                    profilePath: URL(string: "/8e6mt0vGjPo6eW52gqRuXy5YnfN.jpg"),
                    gender: .male,
                    order: 1
                )
            ],
            crew: [
                CrewMember(
                    id: "1084242-76595-d",
                    personID: 76595,
                    personName: "Byron Howard",
                    job: "Director",
                    profilePath: URL(string: "/ePJXkxrD44nM0VB7Xx9Q4ityzfT.jpg"),
                    gender: .male,
                    department: "Directing"
                )
            ]
        )
    ]

}
