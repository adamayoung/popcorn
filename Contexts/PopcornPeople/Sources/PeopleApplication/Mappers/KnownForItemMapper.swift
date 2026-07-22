//
//  KnownForItemMapper.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import PeopleDomain

struct KnownForItemMapper {

    func map(
        _ credit: PersonCredit,
        imagesConfiguration: ImagesConfiguration,
        logoURLSet: ImageURLSet?
    ) -> KnownForItem {
        KnownForItem(
            id: credit.id,
            mediaType: map(credit.mediaType),
            title: credit.title,
            backdropURLSet: imagesConfiguration.backdropURLSet(for: credit.backdropPath),
            logoURLSet: logoURLSet
        )
    }

    private func map(_ mediaType: PersonCredit.MediaType) -> KnownForItem.MediaType {
        switch mediaType {
        case .movie: .movie
        case .tvSeries: .tvSeries
        }
    }

}
