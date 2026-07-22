//
//  DefaultFetchPersonCreditsUseCase.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import PeopleDomain

final class DefaultFetchPersonCreditsUseCase: FetchPersonCreditsUseCase {

    private let repository: any PersonRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        repository: some PersonRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.repository = repository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func execute(personID: Person.ID) async throws(FetchPersonCreditsError) -> [PersonCreditItem] {
        let credits: [PersonCredit]
        let appConfiguration: AppConfiguration
        do {
            async let creditsTask = repository.combinedCredits(forPerson: personID)
            async let appConfigurationTask = appConfigurationProvider.appConfiguration()
            (credits, appConfiguration) = try await (creditsTask, appConfigurationTask)
        } catch let error {
            throw FetchPersonCreditsError(error)
        }

        let mapper = PersonCreditItemMapper()
        return groupedAndSorted(credits).map { group in
            mapper.map(group, imagesConfiguration: appConfiguration.images)
        }
    }

}

extension DefaultFetchPersonCreditsUseCase {

    /// Groups credits per title — keyed by media type and id, so a movie and a
    /// TV series sharing a TMDb id stay separate — and sorts the groups newest
    /// first by date. Undated titles (typically unreleased) lead, and a date tie
    /// breaks by title then id so the order is deterministic.
    private func groupedAndSorted(_ credits: [PersonCredit]) -> [[PersonCredit]] {
        var order: [CreditKey] = []
        var groups: [CreditKey: [PersonCredit]] = [:]
        for credit in credits {
            let key = CreditKey(credit)
            if groups[key] == nil {
                order.append(key)
            }
            groups[key, default: []].append(credit)
        }

        return order
            .compactMap { groups[$0] }
            .sorted(by: isOrderedBefore)
    }

    private func isOrderedBefore(_ lhs: [PersonCredit], _ rhs: [PersonCredit]) -> Bool {
        let lhsDate = lhs.compactMap(\.releaseDate).first
        let rhsDate = rhs.compactMap(\.releaseDate).first

        switch (lhsDate, rhsDate) {
        case (nil, .some):
            return true
        case (.some, nil):
            return false
        case (.some(let lhsDate), .some(let rhsDate)) where lhsDate != rhsDate:
            return lhsDate > rhsDate
        default:
            break
        }

        if lhs[0].title != rhs[0].title {
            return lhs[0].title < rhs[0].title
        }

        return lhs[0].id < rhs[0].id
    }

}

/// The identity of a credited title: a person can hold both cast and crew
/// credits for the same title, and a movie and TV series can share an id.
private struct CreditKey: Hashable {

    let isMovie: Bool
    let id: Int

    init(_ credit: PersonCredit) {
        self.isMovie = credit.mediaType == .movie
        self.id = credit.id
    }

}
