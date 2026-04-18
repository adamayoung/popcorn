//
//  EPGChannelNumberDTO.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

struct EPGChannelNumberDTO: Decodable {

    let channelNumber: String
    let subbouquetIDs: [Int]

}
