//
//  GenderMapper.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain
import TMDb

struct GenderMapper {

    func map(_ gender: TMDb.Gender) -> CoreDomain.Gender {
        switch gender {
        case .unknown: .unknown
        case .female: .female
        case .male: .male
        case .other: .other
        }
    }

    func compactMap(_ gender: TMDb.Gender?) -> CoreDomain.Gender? {
        guard let gender else {
            return nil
        }

        return map(gender)
    }

}
