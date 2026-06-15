//
//  TVChannelNumber.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents a channel-number assignment (e.g. "101" on Sky) and the regions it applies in.
///
/// A channel can carry a different number in different regions, so each number lists the
/// ``TVChannelRegion`` pairs where it applies. Join those to ``TVRegion`` to label or filter.
///
public struct TVChannelNumber: Equatable, Sendable {

    public let channelNumber: String

    public let regions: [TVChannelRegion]

    public init(channelNumber: String, regions: [TVChannelRegion]) {
        self.channelNumber = channelNumber
        self.regions = regions
    }

}
