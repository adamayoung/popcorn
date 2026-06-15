//
//  TVRegionFiltering.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Pure region business rules: grouping the published ``TVRegion`` rows into selectable
/// areas, and deciding which channels belong to an area. Matching is on the full
/// `(bouquet, subBouquet)` pair, so an area in one nation can't capture another nation's
/// channels (subBouquet numbers repeat across nations).
///
public enum TVRegionFiltering {

    ///
    /// Collapses the region rows into one ``TVRegionGroup`` per `(nation, subBouquet)` area,
    /// merging each area's HD and SD ``TVRegion`` pairs. Groups are sorted by name.
    ///
    public static func groups(from regions: [TVRegion]) -> [TVRegionGroup] {
        let grouped = Dictionary(grouping: regions) { GroupKey(nation: $0.nation, subBouquet: $0.subBouquet) }

        return grouped.map { key, rows in
            TVRegionGroup(
                nation: key.nation,
                name: rows.first?.name ?? "",
                subBouquet: key.subBouquet,
                pairs: rows.map { ChannelRegion(bouquet: $0.bouquet, subBouquet: $0.subBouquet) }
            )
        }
        .sorted { lhs, rhs in
            let nameOrder = lhs.name.localizedCaseInsensitiveCompare(rhs.name)
            if nameOrder != .orderedSame {
                return nameOrder == .orderedAscending
            }
            return lhs.id < rhs.id
        }
    }

    ///
    /// The channels available in `group` — those whose any channel-number region matches one
    /// of the group's `(bouquet, subBouquet)` pairs.
    ///
    public static func channels(_ channels: [Channel], in group: TVRegionGroup) -> [Channel] {
        channels.filter { channel in
            channel.channelNumbers.contains { number in
                number.regions.contains { group.pairs.contains($0) }
            }
        }
    }

    private struct GroupKey: Hashable {
        let nation: String
        let subBouquet: Int
    }

}
