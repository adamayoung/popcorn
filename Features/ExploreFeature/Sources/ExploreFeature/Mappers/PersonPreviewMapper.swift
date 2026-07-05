//
//  PersonPreviewMapper.swift
//  ExploreFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TrendingApplication

/// Maps a context ``PersonPreviewDetails`` to the feature's ``PersonPreview`` presentation model.
public struct PersonPreviewMapper {

    /// Creates a person-preview mapper.
    public init() {}

    /// Maps a context ``PersonPreviewDetails`` to a presentation ``PersonPreview``.
    public func map(_ personPreviewDetails: PersonPreviewDetails) -> PersonPreview {
        PersonPreview(
            id: personPreviewDetails.id,
            name: personPreviewDetails.name,
            profileURL: personPreviewDetails.profileURLSet?.detail,
            initials: personPreviewDetails.initials
        )
    }

}
