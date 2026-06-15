//
//  ChannelNumberEntity.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData
import TVListingsDomain

@Model
final class ChannelNumberEntity: Equatable {

    var channelID: String
    var channelNumber: String
    /// `ChannelRegion` is a `Codable` value type, so SwiftData persists the array inline
    /// (the same strategy the previous `[Int]` storage used).
    var regions: [ChannelRegion]

    init(channelID: String, channelNumber: String, regions: [ChannelRegion]) {
        self.channelID = channelID
        self.channelNumber = channelNumber
        self.regions = regions
    }

}
