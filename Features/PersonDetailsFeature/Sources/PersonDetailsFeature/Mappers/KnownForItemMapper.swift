//
//  KnownForItemMapper.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PeopleApplication

/// Maps a context ``PeopleApplication/KnownForItem`` to the feature's presentation model.
public struct KnownForItemMapper {

    /// Creates a known-for-item mapper.
    public init() {}

    /// Maps a context ``PeopleApplication/KnownForItem`` to a presentation ``KnownForItem``.
    public func map(_ item: PeopleApplication.KnownForItem) -> KnownForItem {
        KnownForItem(
            id: item.id,
            mediaType: map(item.mediaType),
            title: item.title,
            backdropURL: item.backdropURLSet?.detail,
            logoURL: item.logoURLSet?.thumbnail
        )
    }

    private func map(_ mediaType: PeopleApplication.KnownForItem.MediaType) -> KnownForItem.MediaType {
        switch mediaType {
        case .movie: .movie
        case .tvSeries: .tvSeries
        }
    }

}
