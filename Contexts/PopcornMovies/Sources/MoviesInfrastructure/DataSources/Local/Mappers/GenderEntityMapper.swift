//
//  GenderEntityMapper.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

struct GenderEntityMapper {

    func map(_ gender: Gender) -> Int {
        switch gender {
        case .unknown: 0
        case .female: 1
        case .male: 2
        case .other: 3
        }
    }

    func map(_ genderCode: Int) -> Gender {
        switch genderCode {
        case 1: .female
        case 2: .male
        case 3: .other
        default: .unknown
        }
    }

}
