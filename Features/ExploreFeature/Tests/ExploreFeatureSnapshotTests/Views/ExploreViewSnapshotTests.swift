//
//  ExploreViewSnapshotTests.swift
//  ExploreFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
@testable import ExploreFeature
import SnapshotTesting
import SwiftUI
import Testing

@Suite("ExploreViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct ExploreViewSnapshotTests {

    @Test
    func exploreView() {
        let view = NavigationStack {
            ExploreView(
                store: Store(
                    initialState: .init(
                        viewState: .ready(
                            .init(
                                discoverMovies: MoviePreview.discoverSnapshots,
                                trendingMovies: MoviePreview.trendingSnapshots,
                                popularMovies: MoviePreview.popularSnapshots,
                                trendingTVSeries: TVSeriesPreview.snapshots,
                                trendingPeople: PersonPreview.snapshots
                            )
                        )
                    ),
                    reducer: { EmptyReducer() }
                )
            )
        }

        assertSnapshot(
            of: view,
            as: .image(layout: .device(config: .iPhone13Pro))
        )
    }

}

extension MoviePreview {

    static var discoverSnapshots: [MoviePreview] {
        [
            MoviePreview(
                id: 83533,
                title: "Avatar: Fire and Ash",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w780/bRBeSHfGHwkEpImlhxPmOcUsaeg.jpg"),
                backdropURL: URL(string: "https://image.tmdb.org/t/p/w1280/sdZSjtGUTSN8B3al5o0f2WoQfQQ.jpg")
            ),
            MoviePreview(
                id: 1_368_166,
                title: "The Housemaid",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w780/cWsBscZzwu5brg9YjNkGewRUvJX.jpg"),
                backdropURL: URL(string: "https://image.tmdb.org/t/p/w1280/tNONILTe9OJz574KZWaLze4v6RC.jpg")
            ),
            MoviePreview(
                id: 1_084_242,
                title: "Zootopia 2",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w780/oJ7g2CifqpStmoYQyaLQgEU32qO.jpg"),
                backdropURL: URL(string: "https://image.tmdb.org/t/p/w1280/7nfpkR9XsQ1lBNCXSSHxGV7Dkxe.jpg")
            ),
            MoviePreview(
                id: 1_159_559,
                title: "Scream 7",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w780/jjyuk0edLiW8vOSnlfwWCCLpbh5.jpg"),
                backdropURL: URL(string: "https://image.tmdb.org/t/p/w1280/yWCZc2TcsCYbMMjvUIsczmQi2TX.jpg")
            )
        ]
    }

    static var trendingSnapshots: [MoviePreview] {
        [
            MoviePreview(
                id: 1_317_288,
                title: "Marty Supreme",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w780/lYWEXbQgRTR4ZQleSXAgRbxAjvq.jpg"),
                backdropURL: URL(string: "https://image.tmdb.org/t/p/w1280/bHtlDAORBQiYKCJMwDP9WBgcQHM.jpg")
            ),
            MoviePreview(
                id: 1_236_153,
                title: "Mercy",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w780/pyok1kZJCfyuFapYXzHcy7BLlQa.jpg"),
                backdropURL: URL(string: "https://image.tmdb.org/t/p/w1280/7HKpc11uQfxnw0Y8tRUYn1fsKqE.jpg")
            ),
            MoviePreview(
                id: 1_272_837,
                title: "28 Years Later: The Bone Temple",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w780/kK1BGkG3KAvWB0WMV1DfOx9yTMZ.jpg"),
                backdropURL: URL(string: "https://image.tmdb.org/t/p/w1280/ryynYdXgP2vLZKH3154bLkNp1kx.jpg")
            ),
            MoviePreview(
                id: 1_315_303,
                title: "Primate",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w780/rKleYiEj4pFqxedTRWfujLooi84.jpg"),
                backdropURL: URL(string: "https://image.tmdb.org/t/p/w1280/9uakM2woks0JV8HKIc4oatIVS88.jpg")
            )
        ]
    }

    static var popularSnapshots: [MoviePreview] {
        [
            MoviePreview(
                id: 1_242_898,
                title: "Predator: Badlands",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w780/erTRAi241eYF4K8KoGGOI8kFPox.jpg"),
                backdropURL: URL(string: "https://image.tmdb.org/t/p/w1280/82lM4GJ9uuNvNDOEpxFy77uv4Ak.jpg")
            ),
            MoviePreview(
                id: 858_024,
                title: "Hamnet",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w780/vbeyOZm2bvBXcbgPD3v6o94epPX.jpg"),
                backdropURL: URL(string: "https://image.tmdb.org/t/p/w1280/73BClq9FOcrWrutnpiqhCNEWEwJ.jpg")
            ),
            MoviePreview(
                id: 1_171_145,
                title: "Crime 101",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w780/2HoR2x23bqKpopluoBD1FH3tBi7.jpg"),
                backdropURL: URL(string: "https://image.tmdb.org/t/p/w1280/s6aB9kjxNg0mu2361IkCUSpyHJV.jpg")
            ),
            MoviePreview(
                id: 425_274,
                title: "Now You See Me: Now You Don't",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w780/oD3Eey4e4Z259XLm3eD3WGcoJAh.jpg"),
                backdropURL: URL(string: "https://image.tmdb.org/t/p/w1280/dHSz0tSFuO2CsXJ1CApSauP9Ncl.jpg")
            )
        ]
    }

}

extension TVSeriesPreview {

    static var snapshots: [TVSeriesPreview] {
        [
            TVSeriesPreview(
                id: 224_372,
                name: "A Knight of the Seven Kingdoms",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w780/k8yARbD9iYn2nRX2HvsopfKDN2r.jpg"),
                backdropURL: URL(string: "https://image.tmdb.org/t/p/w1280/7mkUu1F2hVUNgz24xO8HPx0D6mK.jpg")
            ),
            TVSeriesPreview(
                id: 106_379,
                name: "Fallout",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w780/c15BtJxCXMrISLVmysdsnZUPQft.jpg"),
                backdropURL: URL(string: "https://image.tmdb.org/t/p/w1280/coaPCIqQBPUZsOnJcWZxhaORcDT.jpg")
            ),
            TVSeriesPreview(
                id: 66732,
                name: "Stranger Things",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w780/uOOtwVbSr4QDjAGIifLDwpb2Pdl.jpg"),
                backdropURL: URL(string: "https://image.tmdb.org/t/p/w1280/8zbAoryWbtH0DKdev8abFAjdufy.jpg")
            ),
            TVSeriesPreview(
                id: 250_307,
                name: "The Pitt",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w780/kvFSpESyBZMjaeOJDx7RS3P1jey.jpg"),
                backdropURL: URL(string: "https://image.tmdb.org/t/p/w1280/6uPBHw488MUW6x51zZ2OCJo6Dgp.jpg")
            )
        ]
    }

}

extension PersonPreview {

    static var snapshots: [PersonPreview] {
        [
            PersonPreview(
                id: 86654,
                name: "Austin Butler",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/atdAs4pFGjUQ4m2W8kJYly7N6cC.jpg")
            ),
            PersonPreview(
                id: 70851,
                name: "Jack Black",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/59IhgCtiWI5yTfzPhsjzg7GjCjm.jpg")
            ),
            PersonPreview(
                id: 18897,
                name: "Jackie Chan",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/nraZoTzwJQPHspAVsKfgl3RXKKa.jpg")
            ),
            PersonPreview(
                id: 234_352,
                name: "Margot Robbie",
                profileURL: URL(string: "https://image.tmdb.org/t/p/h632/8LqG2N6j98lFGMpuYsRUAhOunSd.jpg")
            )
        ]
    }

}
