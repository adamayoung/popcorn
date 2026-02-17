//
//  StubMediaProvider.swift
//  PopcornSearchAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import SearchDomain

final class StubMediaProvider: MediaProviding, Sendable {

    func movie(withID id: Int) async throws(MediaProviderError) -> MoviePreview {
        guard let movie = Self.movies[id] else {
            throw .notFound
        }
        return movie
    }

    func tvSeries(withID id: Int) async throws(MediaProviderError) -> TVSeriesPreview {
        guard let tvSeries = Self.tvSeries[id] else {
            throw .notFound
        }
        return tvSeries
    }

    func person(withID id: Int) async throws(MediaProviderError) -> PersonPreview {
        guard let person = Self.people[id] else {
            throw .notFound
        }
        return person
    }

}

extension StubMediaProvider {

    // MARK: - TMDb Data

    // swiftlint:disable line_length
    static let movies: [Int: MoviePreview] = [
        83533: MoviePreview(
            id: 83533,
            title: "Avatar: Fire and Ash",
            overview: "In the wake of the devastating war against the RDA and the loss of their eldest son, Jake Sully and Neytiri face a new threat on Pandora.",
            posterPath: URL(string: "/cf7hE1ifY4UNbS25tGnaTyyDrI2.jpg"),
            backdropPath: URL(string: "/vm4H1DivjQoNIm0Vs6i3CTzFxQ0.jpg")
        ),
        1_242_898: MoviePreview(
            id: 1_242_898,
            title: "Predator: Badlands",
            overview: "Cast out from his clan, a young Predator finds an unlikely ally in a damaged android.",
            posterPath: URL(string: "/pHpq9yNUIo6aDoCXEBzjSolywgz.jpg"),
            backdropPath: URL(string: "/ebyxeBh56QNXxSJgTnmz7fXAlwk.jpg")
        )
    ]

    static let tvSeries: [Int: TVSeriesPreview] = [
        66732: TVSeriesPreview(
            id: 66732,
            name: "Stranger Things",
            overview: "When a young boy vanishes, a small town uncovers a mystery involving secret experiments.",
            posterPath: URL(string: "/uOOtwVbSr4QDjAGIifLDwpb2Pdl.jpg"),
            backdropPath: URL(string: "/8zbAoryWbtH0DKdev8abFAjdufy.jpg")
        ),
        106_379: TVSeriesPreview(
            id: 106_379,
            name: "Fallout",
            overview: "The story of haves and have-nots in a world in which there's almost nothing left to have.",
            posterPath: URL(string: "/c15BtJxCXMrISLVmysdsnZUPQft.jpg"),
            backdropPath: URL(string: "/coaPCIqQBPUZsOnJcWZxhaORcDT.jpg")
        )
    ]

    static let people: [Int: PersonPreview] = [
        500: PersonPreview(
            id: 500,
            name: "Tom Cruise",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: URL(string: "/3mShHjSQR7NXOVbdTu5rT2Qd0MN.jpg")
        ),
        115_440: PersonPreview(
            id: 115_440,
            name: "Sydney Sweeney",
            knownForDepartment: "Acting",
            gender: .female,
            profilePath: URL(string: "/qYiaSl0Eb7G3VaxOg8PxExCFwon.jpg")
        )
    ]
    // swiftlint:enable line_length

}
