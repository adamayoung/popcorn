//
//  EpisodeDetails.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

struct EpisodeDetails: Equatable, Sendable {

    let name: String
    let overview: String?
    let airDate: Date?
    let stillURL: URL?

}
