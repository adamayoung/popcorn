//
//  TVChannelNumber.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents a channel-number assignment (e.g. "101" on Sky) and the bouquets it belongs to.
///
public struct TVChannelNumber: Equatable, Sendable {

    public let channelNumber: String

    public let subbouquetIDs: [Int]

    public init(channelNumber: String, subbouquetIDs: [Int]) {
        self.channelNumber = channelNumber
        self.subbouquetIDs = subbouquetIDs
    }

}
