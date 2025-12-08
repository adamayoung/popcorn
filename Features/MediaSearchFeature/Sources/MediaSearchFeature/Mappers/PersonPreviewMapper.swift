//
//  PersonPreviewMapper.swift
//  MediaSearchFeature
//
//  Created by Adam Young on 21/11/2025.
//

import Foundation
import SearchApplication

struct PersonPreviewMapper {

    func map(_ personPreviewDetails: PersonPreviewDetails) -> PersonPreview {
        PersonPreview(
            id: personPreviewDetails.id,
            name: personPreviewDetails.name,
            profileURL: personPreviewDetails.profileURLSet?.thumbnail
        )
    }

}
