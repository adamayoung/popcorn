//
//  StubMediaRepository.swift
//  PopcornSearchAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import SearchDomain

public final class StubMediaRepository: MediaRepository, Sendable {

    public init() {}

    public func search(query: String, page: Int) async throws(MediaRepositoryError) -> [MediaPreview] {
        Self.searchResults
    }

    public func mediaSearchHistory() async throws(MediaRepositoryError) -> [MediaSearchHistoryEntry] {
        []
    }

    public func saveMovieSearchHistoryEntry(
        _ entry: MovieSearchHistoryEntry
    ) async throws(MediaRepositoryError) {
        // No-op for stub
    }

    public func saveTVSeriesSearchHistoryEntry(
        _ entry: TVSeriesSearchHistoryEntry
    ) async throws(MediaRepositoryError) {
        // No-op for stub
    }

    public func savePersonSearchHistoryEntry(
        _ entry: PersonSearchHistoryEntry
    ) async throws(MediaRepositoryError) {
        // No-op for stub
    }

}

extension StubMediaRepository {

    // MARK: - TMDb Search Results

    // swiftlint:disable line_length
    static let searchResults: [MediaPreview] = [
        // Movie: Avatar: Fire and Ash
        .movie(MoviePreview(
            id: 83533,
            title: "Avatar: Fire and Ash",
            overview: "In the wake of the devastating war against the RDA and the loss of their eldest son, Jake Sully and Neytiri face a new threat on Pandora: the Ash People.",
            posterPath: URL(string: "/cf7hE1ifY4UNbS25tGnaTyyDrI2.jpg"),
            backdropPath: URL(string: "/vm4H1DivjQoNIm0Vs6i3CTzFxQ0.jpg")
        )),
        // Movie: Predator: Badlands
        .movie(MoviePreview(
            id: 1_242_898,
            title: "Predator: Badlands",
            overview: "Cast out from his clan, a young Predator finds an unlikely ally in a damaged android and embarks on a treacherous journey.",
            posterPath: URL(string: "/pHpq9yNUIo6aDoCXEBzjSolywgz.jpg"),
            backdropPath: URL(string: "/ebyxeBh56QNXxSJgTnmz7fXAlwk.jpg")
        )),
        // TV Series: Stranger Things
        .tvSeries(TVSeriesPreview(
            id: 66732,
            name: "Stranger Things",
            overview: "When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces, and one strange little girl.",
            posterPath: URL(string: "/uOOtwVbSr4QDjAGIifLDwpb2Pdl.jpg"),
            backdropPath: URL(string: "/8zbAoryWbtH0DKdev8abFAjdufy.jpg")
        )),
        // TV Series: Fallout
        .tvSeries(TVSeriesPreview(
            id: 106_379,
            name: "Fallout",
            overview: "The story of haves and have-nots in a world in which there's almost nothing left to have.",
            posterPath: URL(string: "/c15BtJxCXMrISLVmysdsnZUPQft.jpg"),
            backdropPath: URL(string: "/coaPCIqQBPUZsOnJcWZxhaORcDT.jpg")
        )),
        // Person: Tom Cruise
        .person(PersonPreview(
            id: 500,
            name: "Tom Cruise",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: URL(string: "/3mShHjSQR7NXOVbdTu5rT2Qd0MN.jpg")
        )),
        // Person: Sydney Sweeney
        .person(PersonPreview(
            id: 115_440,
            name: "Sydney Sweeney",
            knownForDepartment: "Acting",
            gender: .female,
            profilePath: URL(string: "/qYiaSl0Eb7G3VaxOg8PxExCFwon.jpg")
        ))
    ]
    // swiftlint:enable line_length

}
