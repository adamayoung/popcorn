//
//  PersonPreviewMapper.swift
//  TrendingPeopleFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TrendingApplication

struct PersonPreviewMapper {

    func map(_ personPreviewDetails: PersonPreviewDetails) -> PersonPreview {
        PersonPreview(
            id: personPreviewDetails.id,
            name: personPreviewDetails.name,
            profileURL: personPreviewDetails.profileURLSet?.thumbnail,
            initials: personPreviewDetails.initials
        )
    }

}
