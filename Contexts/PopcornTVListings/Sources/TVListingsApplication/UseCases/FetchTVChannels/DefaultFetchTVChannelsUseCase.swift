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

        // Order by channel number (nil sorts last), then tie-break by name then id for a deterministic order.
        return channels
            .map { (channel: $0, sortKey: Self.sortKey(for: $0)) }
            .sorted { lhs, rhs in
                switch (lhs.sortKey, rhs.sortKey) {
                case (let lhsKey?, let rhsKey?) where lhsKey != rhsKey:
                    return lhsKey < rhsKey
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

    private static func sortKey(for channel: TVChannel) -> Int? {
        // Non-parseable numbers (e.g. "HD") are excluded; nil = no usable number, sorts last.
        channel.channelNumbers
            .compactMap { Int($0.channelNumber) }
            .min()
    }

}
