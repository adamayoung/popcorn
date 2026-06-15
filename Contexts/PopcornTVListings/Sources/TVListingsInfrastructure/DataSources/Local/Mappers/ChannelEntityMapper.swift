//
//  ChannelEntityMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

struct ChannelEntityMapper {

    func map(_ entity: ChannelEntity, numbers: [ChannelNumberEntity]) -> Channel {
        Channel(
            id: entity.channelID,
            name: entity.name,
            type: ChannelType(rawValue: entity.type) ?? .television,
            isHD: entity.isHD,
            logoURL: entity.logoURL,
            channelNumbers: numbers.map(mapNumber)
        )
    }

    func map(_ channel: Channel) -> ChannelEntity {
        ChannelEntity(
            channelID: channel.id,
            name: channel.name,
            type: channel.type.rawValue,
            isHD: channel.isHD,
            logoURL: channel.logoURL
        )
    }

    func mapNumbers(for channel: Channel) -> [ChannelNumberEntity] {
        channel.channelNumbers.map { number in
            ChannelNumberEntity(
                channelID: channel.id,
                channelNumber: number.channelNumber,
                regions: number.regions
            )
        }
    }

    private func mapNumber(_ entity: ChannelNumberEntity) -> ChannelNumber {
        ChannelNumber(channelNumber: entity.channelNumber, regions: entity.regions)
    }

}
