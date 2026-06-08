//
//  DefaultFetchTVChannelsUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

final class DefaultFetchTVChannelsUseCase: FetchTVChannelsUseCase {

    private let tvChannelRepository: any TVChannelRepository

    init(tvChannelRepository: some TVChannelRepository) {
        self.tvChannelRepository = tvChannelRepository
    }

    func execute() async throws(FetchTVChannelsError) -> [TVChannel] {
        let channels: [TVChannel]
        do {
            channels = try await tvChannelRepository.channels()
        } catch let error {
            throw FetchTVChannelsError(error)
        }

        // Precompute each channel's sort key once, then order by it with a
        // deterministic tie-break (name, then id) so channels sharing a key —
        // notably all the unnumbered ones at `.max` — keep a stable on-screen
        // order regardless of the repository's return order. (Swift's `sorted`
        // is not guaranteed stable, so the tie-break cannot be left implicit.)
        return channels
            .map { (channel: $0, sortKey: Self.sortKey(for: $0)) }
            .sorted { lhs, rhs in
                if lhs.sortKey != rhs.sortKey {
                    return lhs.sortKey < rhs.sortKey
                }
                let nameOrder = lhs.channel.name.localizedCaseInsensitiveCompare(rhs.channel.name)
                if nameOrder != .orderedSame {
                    return nameOrder == .orderedAscending
                }
                return lhs.channel.id < rhs.channel.id
            }
            .map(\.channel)
    }

    private static func sortKey(for channel: TVChannel) -> Int {
        // Channel numbers in the UK EPG data are always whole-number strings, so
        // non-integer values are not expected. Any that fail Int parsing are
        // excluded from the minimum; the channel then sorts last alongside
        // genuinely unnumbered channels.
        channel.channelNumbers
            .compactMap { Int($0.channelNumber) }
            .min() ?? .max
    }

}
