//
//  EPGScheduleDTO.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

struct EPGScheduleDTO: Decodable {

    let date: String
    let programmes: [EPGProgrammeDTO]

}
