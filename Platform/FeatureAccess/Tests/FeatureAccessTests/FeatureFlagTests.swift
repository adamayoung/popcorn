//
//  FeatureFlagTests.swift
//  FeatureAccess
//
//  Copyright © 2026 Adam Young.
//

@testable import FeatureAccess
import Testing

@Suite("FeatureFlag Tests")
struct FeatureFlagTests {

    @Test("allFlags contains expected count")
    func allFlagsContainsExpectedCount() {
        #expect(FeatureFlag.allFlags.count == 16)
    }

    @Test(
        "allFlags contains all known flag IDs",
        arguments: [
            "explore",
            "media_search",
            "explore_discover_movies",
            "explore_trending_movies",
            "explore_popular_movies",
            "explore_trending_tv_series",
            "explore_trending_people",
            "games",
            "plot_remix_game",
            "emoji_plot_decoder_game",
            "poster_pixelation_game",
            "timeline_tangle_game",
            "movie_intelligence",
            "tv_series_intelligence",
            "watchlist",
            "backdrop_focal_point"
        ]
    )
    func allFlagsContainsKnownFlagID(id: String) {
        #expect(FeatureFlag.allFlags.contains { $0.id == id })
    }

    @Test("flag(withID:) returns correct flag for known ID")
    func flagWithIDReturnsCorrectFlag() {
        let flag = FeatureFlag.flag(withID: "explore")

        #expect(flag?.id == "explore")
        #expect(flag?.name == "Explore")
    }

    @Test("flag(withID:) returns nil for unknown ID")
    func flagWithIDReturnsNilForUnknownID() {
        let flag = FeatureFlag.flag(withID: "nonexistent_flag")

        #expect(flag == nil)
    }

    @Test("each flag has non-empty name and description")
    func eachFlagHasNonEmptyNameAndDescription() {
        for flag in FeatureFlag.allFlags {
            #expect(!flag.name.isEmpty, "Flag \(flag.id) has empty name")
            #expect(!flag.description.isEmpty, "Flag \(flag.id) has empty description")
        }
    }

}
