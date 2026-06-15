//
//  TVRegionGroup.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A user-selectable region (area), collapsing an area's HD and SD ``TVRegion`` rows into
/// one entry. An area is identified by its `(nation, subBouquet)`; ``pairs`` holds every
/// `(bouquet, subBouquet)` the area spans (typically one HD and one SD), used to match
/// channels via ``ChannelNumber/regions``.
///
public struct TVRegionGroup: Identifiable, Equatable, Sendable {

    public let nation: String

    public let name: String

    public let subBouquet: Int

    public let pairs: [ChannelRegion]

    /// Stable identity scoped to a nation's area index — distinct from ``TVRegion/id``.
    public var id: String {
        "\(nation)#\(subBouquet)"
    }

    public init(nation: String, name: String, subBouquet: Int, pairs: [ChannelRegion]) {
        self.nation = nation
        self.name = name
        self.subBouquet = subBouquet
        self.pairs = pairs
    }

}
