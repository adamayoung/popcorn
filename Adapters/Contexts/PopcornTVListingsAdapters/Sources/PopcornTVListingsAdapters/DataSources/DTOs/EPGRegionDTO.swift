//
//  EPGRegionDTO.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// A single entry in `regions.json`: a Sky region keyed by its `(bouquet, subBouquet)` pair.
struct EPGRegionDTO: Decodable {

    let bouquet: Int
    let subBouquet: Int
    let name: String
    let nation: String
    let isHD: Bool

}

/// The top-level shape of `regions.json`.
struct EPGRegionsResponseDTO: Decodable {

    let regions: [EPGRegionDTO]

}
