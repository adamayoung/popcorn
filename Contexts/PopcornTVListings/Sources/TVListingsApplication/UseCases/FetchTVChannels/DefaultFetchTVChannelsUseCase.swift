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
        return Self.preferringHDVariants(channels)
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

    /// Collapses SD/HD duplicates. When the same channel is published in both a
    /// standard-definition and a high-definition variant — matched by name,
    /// ignoring a trailing "HD" designation — only the HD variant (``TVChannel/isHD``)
    /// is kept. Channels published in a single variant are returned unchanged.
    private static func preferringHDVariants(_ channels: [TVChannel]) -> [TVChannel] {
        let groups = Dictionary(grouping: channels) { baseName(for: $0) }
        let sdIDsToDrop = groups.values.reduce(into: Set<String>()) { result, group in
            // Only drop SD variants when an HD counterpart of the same channel exists.
            guard group.contains(where: \.isHD) else {
                return
            }
            for channel in group where !channel.isHD {
                result.insert(channel.id)
            }
        }

        guard !sdIDsToDrop.isEmpty else {
            return channels
        }
        return channels.filter { !sdIDsToDrop.contains($0.id) }
    }

    /// The channel name lowercased with a trailing "HD" designation removed, so
    /// "BBC One" and "BBC One HD" resolve to the same base name.
    private static func baseName(for channel: TVChannel) -> String {
        var tokens = channel.name.lowercased().split(separator: " ")
        if tokens.last == "hd" {
            tokens.removeLast()
        }
        return tokens.joined(separator: " ")
    }

}
