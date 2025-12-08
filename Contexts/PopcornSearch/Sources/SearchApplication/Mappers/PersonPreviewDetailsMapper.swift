//
//  PersonPreviewDetailsMapper.swift
//  PopcornSearch
//
//  Created by Adam Young on 20/11/2025.
//

import CoreDomain
import Foundation
import SearchDomain

struct PersonPreviewDetailsMapper {

    func map(_ personPreview: PersonPreview, imagesConfiguration: ImagesConfiguration)
        -> PersonPreviewDetails
    {
        let profileURLSet = imagesConfiguration.posterURLSet(for: personPreview.profilePath)

        return PersonPreviewDetails(
            id: personPreview.id,
            name: personPreview.name,
            knownForDepartment: personPreview.knownForDepartment,
            gender: personPreview.gender,
            profileURLSet: profileURLSet
        )
    }

}
