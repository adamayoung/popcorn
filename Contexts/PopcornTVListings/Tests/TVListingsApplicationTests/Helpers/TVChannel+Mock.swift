//
//  TVChannel+Mock.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

extension TVChannel {

    static func mock(
        id: String = "BBC",
        name: String = "BBC",
        isHD: Bool = false,
        logoURL: URL? = nil,
        channelNumbers: [TVChannelNumber] = []
    ) -> TVChannel {
        TVChannel(
            id: id,
            name: name,
            isHD: isHD,
            logoURL: logoURL,
            channelNumbers: channelNumbers
        )
    }

}
