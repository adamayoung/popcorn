//
//  PersonPreviewMapper.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TMDb
import TrendingDomain

struct PersonPreviewMapper {

    func map(_ dto: PersonListItem) -> PersonPreview {
        PersonPreview(
            id: dto.id,
            name: dto.name,
            knownForDepartment: dto.knownForDepartment,
            gender: map(dto.gender),
            profilePath: dto.profilePath,
            initials: PersonInitials.resolve(from: dto.name)
        )
    }

    private func map(_ dto: TMDb.Gender) -> CoreDomain.Gender {
        switch dto {
        case .unknown: .unknown
        case .female: .female
        case .male: .male
        case .other: .other
        }
    }

}
