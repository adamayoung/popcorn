//
//  TVChannelEntityMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

struct TVChannelEntityMapper {

    func map(_ entity: TVChannelEntity, numbers: [TVChannelNumberEntity]) -> TVChannel {
        TVChannel(
            id: entity.channelID,
            name: entity.name,
            isHD: entity.isHD,
            logoURL: entity.logoURL,
            channelNumbers: numbers.map(mapNumber)
        )
    }

    func map(_ channel: TVChannel) -> TVChannelEntity {
        TVChannelEntity(
            channelID: channel.id,
            name: channel.name,
            isHD: channel.isHD,
            logoURL: channel.logoURL
        )
    }

    func mapNumbers(for channel: TVChannel) -> [TVChannelNumberEntity] {
        channel.channelNumbers.map { number in
            TVChannelNumberEntity(
                channelID: channel.id,
                channelNumber: number.channelNumber,
                subbouquetIDs: number.subbouquetIDs
            )
        }
    }

    private func mapNumber(_ entity: TVChannelNumberEntity) -> TVChannelNumber {
        TVChannelNumber(channelNumber: entity.channelNumber, subbouquetIDs: entity.subbouquetIDs)
    }

}
