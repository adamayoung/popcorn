//
//  ChannelRegion.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Identifies a Sky region — a `(bouquet, subBouquet)` pair — that a channel number
/// applies to. Join to ``TVRegion`` on the same pair to resolve the region's name,
/// nation, and resolution (HD/SD).
///
/// `Codable` conformance exists so SwiftData can persist `ChannelNumberEntity.regions`
/// as an inline value-type array; it isn't used by the domain itself.
///
public struct ChannelRegion: Codable, Equatable, Hashable, Sendable {

    public let bouquet: Int

    public let subBouquet: Int

    public init(bouquet: Int, subBouquet: Int) {
        self.bouquet = bouquet
        self.subBouquet = subBouquet
    }

}
