//
//  PersonPreviewMapper.swift
//  PopcornSearchAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import SearchDomain
import TMDb

///
/// A mapper that converts TMDb person list items to domain person previews.
///
struct PersonPreviewMapper {

    ///
    /// Maps a TMDb person list item to a domain person preview.
    ///
    /// - Parameter dto: The TMDb person list item to map.
    ///
    /// - Returns: A ``PersonPreview`` populated with the person data.
    ///
    func map(_ dto: PersonListItem) -> PersonPreview {
        PersonPreview(
            id: dto.id,
            name: dto.name,
            knownForDepartment: dto.knownForDepartment,
            gender: map(dto.gender),
            profilePath: dto.profilePath
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
