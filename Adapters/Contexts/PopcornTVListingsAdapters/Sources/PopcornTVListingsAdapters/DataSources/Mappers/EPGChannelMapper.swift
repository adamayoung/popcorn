//
//  EPGChannelMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

struct EPGChannelMapper {

    func map(_ dto: EPGChannelDTO) -> TVChannel {
        TVChannel(
            id: dto.sid,
            name: dto.name,
            isHD: dto.isHD,
            logoURL: dto.logoURL,
            channelNumbers: dto.channelNumbers.map { number in
                TVChannelNumber(
                    channelNumber: number.channelNumber,
                    subbouquetIDs: number.subbouquetIDs
                )
            }
        )
    }

}
