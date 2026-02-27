//
//  PersonPreviewDetailsMapper.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TrendingDomain

struct PersonPreviewDetailsMapper {

    func map(_ personPreview: PersonPreview, imagesConfiguration: ImagesConfiguration)
    -> PersonPreviewDetails {
        let profileURLSet = imagesConfiguration.posterURLSet(for: personPreview.profilePath)

        return PersonPreviewDetails(
            id: personPreview.id,
            name: personPreview.name,
            knownForDepartment: personPreview.knownForDepartment,
            gender: personPreview.gender,
            profileURLSet: profileURLSet,
            initials: personPreview.initials
        )
    }

}
