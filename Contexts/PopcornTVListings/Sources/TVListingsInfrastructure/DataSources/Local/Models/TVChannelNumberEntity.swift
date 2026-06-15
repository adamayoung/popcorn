//
//  TVChannelNumberEntity.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData
import TVListingsDomain

@Model
final class TVChannelNumberEntity: Equatable {

    var channelID: String
    var channelNumber: String
    /// `TVChannelRegion` is a `Codable` value type, so SwiftData persists the array inline
    /// (the same strategy the previous `[Int]` storage used).
    var regions: [TVChannelRegion]

    init(channelID: String, channelNumber: String, regions: [TVChannelRegion]) {
        self.channelID = channelID
        self.channelNumber = channelNumber
        self.regions = regions
    }

}
