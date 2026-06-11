//
//  EPGProgrammeDTO+Mock.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTVListingsAdapters

extension EPGProgrammeDTO {

    static func mock(
        title: String = "Programme",
        description: String? = nil,
        startTime: TimeInterval = 1_776_463_200,
        duration: TimeInterval = 1800,
        episodeNumber: Int? = nil,
        seasonNumber: Int? = nil,
        imageURL: URL? = nil,
        tmdbTVSeriesID: Int? = nil,
        tmdbMovieID: Int? = nil,
        genres: [String]? = nil,
        certification: String? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil,
        isPremiere: Bool? = nil,
        keywords: [String]? = nil,
        watchProviders: [String]? = nil
    ) -> EPGProgrammeDTO {
        EPGProgrammeDTO(
            title: title,
            description: description,
            startTime: startTime,
            duration: duration,
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            imageURL: imageURL,
            tmdbTVSeriesID: tmdbTVSeriesID,
            tmdbMovieID: tmdbMovieID,
            genres: genres,
            certification: certification,
            voteAverage: voteAverage,
            voteCount: voteCount,
            isPremiere: isPremiere,
            keywords: keywords,
            watchProviders: watchProviders
        )
    }

}
