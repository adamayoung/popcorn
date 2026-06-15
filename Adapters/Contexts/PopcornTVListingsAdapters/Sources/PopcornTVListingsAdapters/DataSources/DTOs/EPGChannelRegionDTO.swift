//
//  EPGChannelRegionDTO.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// A `(bouquet, subBouquet)` region pair a channel number applies in, as published in
/// `channels.json`.
struct EPGChannelRegionDTO: Decodable {

    let bouquet: Int
    let subBouquet: Int

}
