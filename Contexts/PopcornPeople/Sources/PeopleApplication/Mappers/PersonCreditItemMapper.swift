//
//  PersonCreditItemMapper.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import PeopleDomain

struct PersonCreditItemMapper {

    /// Maps a group of credits for one title — all sharing the same media type
    /// and id — into a single presentation item. Cast characters lead the parts
    /// list, followed by crew jobs, each in encounter order without duplicates.
    ///
    /// - Precondition: `group` is non-empty.
    func map(_ group: [PersonCredit], imagesConfiguration: ImagesConfiguration) -> PersonCreditItem {
        precondition(!group.isEmpty, "A credit group must contain at least one credit")

        let first = group[0]
        return PersonCreditItem(
            id: first.id,
            mediaType: map(first.mediaType),
            title: first.title,
            parts: parts(of: group),
            date: group.compactMap(\.releaseDate).first,
            posterURLSet: imagesConfiguration.posterURLSet(for: group.compactMap(\.posterPath).first)
        )
    }

    private func map(_ mediaType: PersonCredit.MediaType) -> PersonCreditItem.MediaType {
        switch mediaType {
        case .movie: .movie
        case .tvSeries: .tvSeries
        }
    }

    /// Collects the person's parts on a title: cast characters first, then crew
    /// jobs, preserving encounter order, dropping unknown parts and duplicates.
    private func parts(of group: [PersonCredit]) -> [String] {
        var seen = Set<String>()
        var parts: [String] = []

        let characters = group.compactMap { credit -> String? in
            guard case .cast(let character) = credit.role else {
                return nil
            }
            return character
        }
        let jobs = group.compactMap { credit -> String? in
            guard case .crew(let job, _) = credit.role else {
                return nil
            }
            return job
        }

        for part in characters + jobs where !part.isEmpty && seen.insert(part).inserted {
            parts.append(part)
        }

        return parts
    }

}
