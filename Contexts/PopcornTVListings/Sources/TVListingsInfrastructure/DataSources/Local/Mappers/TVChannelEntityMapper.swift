//
//  TVChannelEntityMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

struct TVChannelEntityMapper {

    func map(_ entity: TVChannelEntity) -> TVChannel {
        TVChannel(
            id: entity.channelID,
            name: entity.name,
            isHD: entity.isHD,
            logoURL: entity.logoURL,
            channelNumbers: entity.channelNumbers.map(mapNumber)
        )
    }

    func map(_ channel: TVChannel) -> TVChannelEntity {
        TVChannelEntity(
            channelID: channel.id,
            name: channel.name,
            isHD: channel.isHD,
            logoURL: channel.logoURL,
            channelNumbers: channel.channelNumbers.map(mapNumber)
        )
    }

    private func mapNumber(_ entity: TVChannelNumberEntity) -> TVChannelNumber {
        TVChannelNumber(channelNumber: entity.channelNumber, subbouquetIDs: entity.subbouquetIDs)
    }

    private func mapNumber(_ number: TVChannelNumber) -> TVChannelNumberEntity {
        TVChannelNumberEntity(channelNumber: number.channelNumber, subbouquetIDs: number.subbouquetIDs)
    }

}
