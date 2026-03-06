//
//  GenreDetailsExtendedMapper.swift
//  PopcornGenres
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import GenresDomain

struct GenreDetailsExtendedMapper {

    private static let palette: [ThemeColor] = [
        ThemeColor(red: 1.0, green: 0.23, blue: 0.19),
        ThemeColor(red: 1.0, green: 0.58, blue: 0.0),
        ThemeColor(red: 1.0, green: 0.8, blue: 0.0),
        ThemeColor(red: 0.2, green: 0.78, blue: 0.35),
        ThemeColor(red: 0.0, green: 0.78, blue: 0.75),
        ThemeColor(red: 0.19, green: 0.67, blue: 0.9),
        ThemeColor(red: 0.0, green: 0.48, blue: 1.0),
        ThemeColor(red: 0.35, green: 0.34, blue: 0.84),
        ThemeColor(red: 0.69, green: 0.32, blue: 0.87),
        ThemeColor(red: 1.0, green: 0.18, blue: 0.33),
        ThemeColor(red: 0.8, green: 0.2, blue: 0.4),
        ThemeColor(red: 0.6, green: 0.4, blue: 0.2),
        ThemeColor(red: 0.2, green: 0.6, blue: 0.4),
        ThemeColor(red: 0.4, green: 0.2, blue: 0.6),
        ThemeColor(red: 0.8, green: 0.5, blue: 0.2),
        ThemeColor(red: 0.3, green: 0.7, blue: 0.5),
        ThemeColor(red: 0.7, green: 0.3, blue: 0.5),
        ThemeColor(red: 0.5, green: 0.5, blue: 0.8),
        ThemeColor(red: 0.9, green: 0.4, blue: 0.3),
        ThemeColor(red: 0.4, green: 0.7, blue: 0.3)
    ]

    func map(
        _ genre: Genre,
        backdropURLSet: ImageURLSet?
    ) -> GenreDetailsExtended {
        GenreDetailsExtended(
            id: genre.id,
            name: genre.name,
            color: Self.color(forGenreID: genre.id),
            backdropURLSet: backdropURLSet
        )
    }

    static func color(forGenreID id: Int) -> ThemeColor {
        var hash = id
        hash = ((hash >> 16) ^ hash) &* 0x45D9F3B
        hash = ((hash >> 16) ^ hash) &* 0x45D9F3B
        hash = (hash >> 16) ^ hash
        return palette[abs(hash) % palette.count]
    }

}
