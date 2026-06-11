//
//  EPGScheduleResponseDTO.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

struct EPGScheduleResponseDTO: Decodable {

    let date: String
    let channels: [EPGScheduleChannelDTO]

}

struct EPGScheduleChannelDTO: Decodable {

    let sid: String
    let programmes: [EPGProgrammeDTO]

}
