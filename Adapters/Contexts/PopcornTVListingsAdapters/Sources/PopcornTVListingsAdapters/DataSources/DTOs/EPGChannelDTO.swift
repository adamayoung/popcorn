//
//  EPGChannelDTO.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

struct EPGChannelDTO: Decodable {

    let sid: String
    let name: String
    let isHD: Bool
    let logoURL: URL?
    let channelNumbers: [EPGChannelNumberDTO]
    let schedules: [EPGScheduleDTO]

}
