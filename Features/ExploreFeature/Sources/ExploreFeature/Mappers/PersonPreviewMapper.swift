//
//  PersonPreviewMapper.swift
//  ExploreFeature
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
            profileURL: personPreviewDetails.profileURLSet?.detail,
            initials: personPreviewDetails.initials
        )
    }

}
