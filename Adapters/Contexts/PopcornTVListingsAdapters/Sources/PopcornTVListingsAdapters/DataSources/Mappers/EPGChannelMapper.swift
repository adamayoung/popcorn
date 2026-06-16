//
//  EPGChannelMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

struct EPGChannelMapper {

    func map(_ dto: EPGChannelDTO) -> Channel {
        Channel(
            id: dto.sid,
            name: dto.name,
            type: ChannelType(rawValue: dto.type) ?? .television,
            isHD: dto.isHD,
            logoURL: dto.logoURL,
            channelNumbers: dto.channelNumbers.map { number in
                ChannelNumber(
                    channelNumber: number.channelNumber,
                    regions: number.regions.map { region in
                        ChannelRegion(bouquet: region.bouquet, subBouquet: region.subBouquet)
                    }
                )
            }
        )
    }

}
