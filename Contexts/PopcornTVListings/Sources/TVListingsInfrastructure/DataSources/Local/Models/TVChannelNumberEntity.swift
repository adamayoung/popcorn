//
//  TVChannelNumberEntity.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class TVChannelNumberEntity: Equatable {

    var channelID: String
    var channelNumber: String
    var subbouquetIDs: [Int]

    init(channelID: String, channelNumber: String, subbouquetIDs: [Int]) {
        self.channelID = channelID
        self.channelNumber = channelNumber
        self.subbouquetIDs = subbouquetIDs
    }

}
