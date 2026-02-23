//
//  TVEpisode.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct TVEpisode: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let episodeNumber: Int
    public let overview: String?
    public let airDate: Date?
    public let stillURL: URL?

}

extension TVEpisode {

    static var mocks: [TVEpisode] {
        [
            TVEpisode(
                id: 62085,
                name: "Pilot",
                episodeNumber: 1,
                overview: "A high school chemistry teacher diagnosed with lung cancer turns to manufacturing meth.",
                airDate: Date(timeIntervalSince1970: 1_200_528_000),
                stillURL: URL(string: "https://image.tmdb.org/t/p/w300/ydlY3iPfeOAvu8gVqrxPoMvzfBj.jpg")
            ),
            TVEpisode(
                id: 62086,
                name: "Cat's in the Bag...",
                episodeNumber: 2,
                overview: "Walt and Jesse attempt to dispose of the bodies.",
                airDate: Date(timeIntervalSince1970: 1_201_132_800),
                stillURL: URL(string: "https://image.tmdb.org/t/p/w300/tjMFCOQDcMGjjH0GIOL7u9gNbB1.jpg")
            ),
            TVEpisode(
                id: 62087,
                name: "...And the Bag's in the River",
                episodeNumber: 3,
                overview: nil,
                airDate: nil,
                stillURL: nil
            )
        ]
    }

}
