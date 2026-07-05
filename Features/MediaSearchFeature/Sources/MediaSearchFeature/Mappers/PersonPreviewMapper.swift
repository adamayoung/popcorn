//
//  PersonPreviewMapper.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SearchApplication

/// Maps a context ``PersonPreviewDetails`` to the feature's ``PersonPreview`` presentation model.
public struct PersonPreviewMapper {

    /// Creates a person-preview mapper.
    public init() {}

    /// Maps a context ``PersonPreviewDetails`` to a presentation ``PersonPreview``.
    public func map(_ personPreviewDetails: PersonPreviewDetails) -> PersonPreview {
        PersonPreview(
            id: personPreviewDetails.id,
            name: personPreviewDetails.name,
            profileURL: personPreviewDetails.profileURLSet?.thumbnail,
            initials: personPreviewDetails.initials
        )
    }

}
