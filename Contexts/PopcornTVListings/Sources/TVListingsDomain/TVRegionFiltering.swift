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
                // An area's HD and SD rows share a name; pick deterministically (lowest
                // bouquet) rather than relying on the unspecified `Dictionary(grouping:)` order.
                name: rows.min { $0.bouquet < $1.bouquet }?.name ?? "",
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
    /// The channels available in `group` — those with a channel number whose regions match one
    /// of the group's `(bouquet, subBouquet)` pairs — **ordered by their channel number within
    /// that region**. A channel is positioned by the lowest of *its numbers that serve this
    /// region*, not its global-lowest number: so another region's variant (e.g. "BBC One West",
    /// whose `101` serves the West but only its `960` serves London) sorts at `960`, leaving the
    /// region-local channel at `101` — matching how a Sky box orders the guide.
    ///
    public static func channels(_ channels: [Channel], in group: TVRegionGroup) -> [Channel] {
        channels
            .compactMap { channel -> (channel: Channel, number: Int?)? in
                let regionNumbers = channel.channelNumbers.filter { number in
                    number.regions.contains { group.pairs.contains($0) }
                }
                guard !regionNumbers.isEmpty else {
                    return nil
                }
                // Lowest parseable number that serves this region; nil (sorts last) if none parse.
                return (channel, regionNumbers.compactMap { Int($0.channelNumber) }.min())
            }
            .sorted { lhs, rhs in
                switch (lhs.number, rhs.number) {
                case (let lhsNumber?, let rhsNumber?) where lhsNumber != rhsNumber:
                    return lhsNumber < rhsNumber
                case (_?, nil):
                    return true
                case (nil, _?):
                    return false
                default:
                    break
                }
                let nameOrder = lhs.channel.name.localizedCaseInsensitiveCompare(rhs.channel.name)
                if nameOrder != .orderedSame {
                    return nameOrder == .orderedAscending
                }
                return lhs.channel.id < rhs.channel.id
            }
            .map(\.channel)
    }

    private struct GroupKey: Hashable {
        let nation: String
        let subBouquet: Int
    }

}
