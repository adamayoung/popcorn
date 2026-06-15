//
//  Channel+Mock.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

extension Channel {

    static func mock(
        id: String = "BBC",
        name: String = "BBC",
        type: ChannelType = .television,
        isHD: Bool = false,
        logoURL: URL? = nil,
        channelNumbers: [ChannelNumber] = []
    ) -> Channel {
        Channel(
            id: id,
            name: name,
            type: type,
            isHD: isHD,
            logoURL: logoURL,
            channelNumbers: channelNumbers
        )
    }

}
