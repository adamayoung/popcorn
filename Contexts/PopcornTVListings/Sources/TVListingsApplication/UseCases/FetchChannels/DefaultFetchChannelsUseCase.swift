//
//  DefaultFetchChannelsUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

final class DefaultFetchChannelsUseCase: FetchChannelsUseCase {

    private let channelRepository: any ChannelRepository

    init(channelRepository: some ChannelRepository) {
        self.channelRepository = channelRepository
    }

    func execute() async throws(FetchChannelsError) -> [Channel] {
        let channels: [Channel]
        do {
            channels = try await channelRepository.channels()
        } catch let error {
            throw FetchChannelsError(error)
        }

        // Order by channel number (nil sorts last), then tie-break by name then id for a deterministic order.
        return Self.preferringHDVariants(Self.excludingRadioStations(channels))
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

    /// Drops radio stations so the TV listings show only TV channels, using the feed's
    /// channel ``Channel/type``.
    private static func excludingRadioStations(_ channels: [Channel]) -> [Channel] {
        channels.filter { $0.type != .radio }
    }

    private static func sortKey(for channel: Channel) -> Int? {
        // Non-parseable numbers (e.g. "HD") are excluded; nil = no usable number, sorts last.
        channel.channelNumbers
            .compactMap { Int($0.channelNumber) }
            .min()
    }

    /// Collapses SD/HD duplicates. When the same channel is published in both a
    /// standard-definition and a high-definition variant — matched by name,
    /// ignoring a trailing "HD" designation — only the HD variant (``Channel/isHD``)
    /// is kept. Channels published in a single variant are returned unchanged.
    ///
    /// - Note: This is an **interim** heuristic keyed on the channel-level ``Channel/isHD``,
    ///   which the feed reports unreliably (it's `false` for every Sky channel today, making
    ///   this a no-op on live data). HD-ness truly lives on the region/bouquet (`regions.json`);
    ///   this should be reworked to resolve HD via ``ChannelNumber/regions`` joined to
    ///   ``TVRegion/isHD``.
    private static func preferringHDVariants(_ channels: [Channel]) -> [Channel] {
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
    private static func baseName(for channel: Channel) -> String {
        var tokens = channel.name.lowercased().split(separator: " ")
        if tokens.last == "hd" {
            tokens.removeLast()
        }
        return tokens.joined(separator: " ")
    }

}
