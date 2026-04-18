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

    var channelNumber: String
    var subbouquetIDs: [Int]
    @Relationship(inverse: \TVChannelEntity.channelNumbers) var channel: TVChannelEntity?

    init(channelNumber: String, subbouquetIDs: [Int]) {
        self.channelNumber = channelNumber
        self.subbouquetIDs = subbouquetIDs
    }

}
