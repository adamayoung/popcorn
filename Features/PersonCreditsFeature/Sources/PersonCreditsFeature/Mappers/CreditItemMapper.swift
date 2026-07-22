//
//  CreditItemMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PeopleApplication

/// Maps a context ``PersonCreditItem`` to the feature's ``CreditItem`` presentation model.
public struct CreditItemMapper {

    private static let partsSeparator = " · "

    /// Creates a credit item mapper.
    public init() {}

    /// Maps an application-layer credit item to the feature's row model, joining
    /// the parts for display and selecting the card-sized poster URL.
    public func map(_ item: PersonCreditItem) -> CreditItem {
        CreditItem(
            mediaID: item.id,
            mediaType: map(item.mediaType),
            title: item.title,
            partsText: item.parts.isEmpty ? nil : item.parts.joined(separator: Self.partsSeparator),
            date: item.date,
            posterURL: item.posterURLSet?.card
        )
    }

    private func map(_ mediaType: PersonCreditItem.MediaType) -> CreditItem.MediaType {
        switch mediaType {
        case .movie: .movie
        case .tvSeries: .tvSeries
        }
    }

}
