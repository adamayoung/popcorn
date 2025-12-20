//
//  PersonPreviewMapper.swift
//  MediaSearchFeature
//
//  Copyright © 2025 Adam Young.
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
