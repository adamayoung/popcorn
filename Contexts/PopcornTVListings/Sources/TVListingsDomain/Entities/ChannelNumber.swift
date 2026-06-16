//
//  ChannelNumber.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents a channel-number assignment (e.g. "101" on Sky) and the regions it applies in.
///
/// A channel can carry a different number in different regions, so each number lists the
/// ``ChannelRegion`` pairs where it applies. Join those to ``TVRegion`` to label or filter.
///
public struct ChannelNumber: Equatable, Sendable {

    public let channelNumber: String

    public let regions: [ChannelRegion]

    public init(channelNumber: String, regions: [ChannelRegion]) {
        self.channelNumber = channelNumber
        self.regions = regions
    }

}
