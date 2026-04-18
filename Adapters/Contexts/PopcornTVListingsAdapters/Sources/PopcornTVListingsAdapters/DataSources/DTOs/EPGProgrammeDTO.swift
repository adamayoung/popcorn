//
//  EPGProgrammeDTO.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

struct EPGProgrammeDTO: Decodable {

    let title: String
    let description: String?
    let startTime: TimeInterval
    let duration: TimeInterval
    let episodeNumber: Int?
    let seasonNumber: Int?
    let imageURL: URL?
    let tmdbTVSeriesID: Int?
    let tmdbMovieID: Int?

}
