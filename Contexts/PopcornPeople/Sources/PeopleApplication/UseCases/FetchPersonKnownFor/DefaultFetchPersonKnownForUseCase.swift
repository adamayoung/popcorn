//
//  DefaultFetchPersonKnownForUseCase.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import PeopleDomain

final class DefaultFetchPersonKnownForUseCase: FetchPersonKnownForUseCase {

    private let repository: any PersonRepository
    private let appConfigurationProvider: any AppConfigurationProviding
    private let movieLogoImageProvider: any MovieLogoImageProviding
    private let tvSeriesLogoImageProvider: any TVSeriesLogoImageProviding

    /// The department TMDb reports for people whose primary work is acting.
    private static let actingDepartment = "Acting"

    /// The number of credits shown in the "Known For" carousel.
    private static let maxItems = 5

    init(
        repository: some PersonRepository,
        appConfigurationProvider: some AppConfigurationProviding,
        movieLogoImageProvider: some MovieLogoImageProviding,
        tvSeriesLogoImageProvider: some TVSeriesLogoImageProviding
    ) {
        self.repository = repository
        self.appConfigurationProvider = appConfigurationProvider
        self.movieLogoImageProvider = movieLogoImageProvider
        self.tvSeriesLogoImageProvider = tvSeriesLogoImageProvider
    }

    func execute(personID: Person.ID) async throws(FetchPersonKnownForError) -> [KnownForItem] {
        let person: Person
        let credits: [PersonCredit]
        let appConfiguration: AppConfiguration
        do {
            async let personTask = repository.person(withID: personID)
            async let creditsTask = repository.combinedCredits(forPerson: personID)
            async let appConfigurationTask = appConfigurationProvider.appConfiguration()
            (person, credits, appConfiguration) = try await (personTask, creditsTask, appConfigurationTask)
        } catch let error {
            throw FetchPersonKnownForError(error)
        }

        // Trim to the shown count before logo enrichment so discarded credits
        // never incur a logo fetch.
        let topCredits = Array(
            rank(credits, knownForDepartment: person.knownForDepartment).prefix(Self.maxItems)
        )

        let logoURLSets = await logoURLSets(for: topCredits)

        let mapper = KnownForItemMapper()
        return topCredits.map { credit in
            mapper.map(
                credit,
                imagesConfiguration: appConfiguration.images,
                logoURLSet: logoURLSets[CreditKey(credit)]
            )
        }
    }

}

extension DefaultFetchPersonKnownForUseCase {

    /// Ranks a person's credits by relevance: filtered to the department they are
    /// known for, dropping backdrop-less credits, deduplicated per title keeping
    /// the more popular instance, and sorted by popularity descending. Falls back
    /// to all backdrop-bearing credits when the department filter yields nothing.
    private func rank(
        _ credits: [PersonCredit],
        knownForDepartment: String
    ) -> [PersonCredit] {
        let departmentCredits = credits
            .filter { isInKnownForDepartment($0, knownForDepartment: knownForDepartment) }
            .filter { $0.backdropPath != nil }

        let candidates = departmentCredits.isEmpty
            ? credits.filter { $0.backdropPath != nil }
            : departmentCredits

        let sorted = candidates.sorted { ($0.popularity ?? 0) > ($1.popularity ?? 0) }
        return deduplicated(sorted)
    }

    /// Whether a credit belongs to the department a person is known for: cast
    /// credits for actors, otherwise crew credits in the matching department.
    private func isInKnownForDepartment(
        _ credit: PersonCredit,
        knownForDepartment: String
    ) -> Bool {
        switch credit.role {
        case .cast:
            knownForDepartment == Self.actingDepartment

        case .crew(let department):
            knownForDepartment != Self.actingDepartment && department == knownForDepartment
        }
    }

    /// Removes duplicate titles, keeping the first occurrence. Callers pass a
    /// popularity-sorted list, so the retained instance is the more popular one.
    private func deduplicated(_ credits: [PersonCredit]) -> [PersonCredit] {
        var seen = Set<CreditKey>()
        var result: [PersonCredit] = []
        for credit in credits where seen.insert(CreditKey(credit)).inserted {
            result.append(credit)
        }
        return result
    }

    /// Fetches each credit's logo concurrently via the media-type-matching
    /// provider. A per-credit failure is tolerated — that credit simply has no
    /// logo — rather than failing the whole request.
    private func logoURLSets(for credits: [PersonCredit]) async -> [CreditKey: ImageURLSet] {
        await withTaskGroup(of: (CreditKey, ImageURLSet?).self) { taskGroup in
            for credit in credits {
                taskGroup.addTask {
                    let logoURLSet: ImageURLSet? = switch credit.mediaType {
                    case .movie:
                        try? await self.movieLogoImageProvider
                            .imageURLSet(forMovie: credit.id)

                    case .tvSeries:
                        try? await self.tvSeriesLogoImageProvider
                            .imageURLSet(forTVSeries: credit.id)
                    }
                    return (CreditKey(credit), logoURLSet)
                }
            }

            var results: [CreditKey: ImageURLSet] = [:]
            for await (key, logoURLSet) in taskGroup {
                if let logoURLSet {
                    results[key] = logoURLSet
                }
            }
            return results
        }
    }

}

/// Identity for a credit — a title's id is only unique within its media type, so
/// both are needed to key and deduplicate credits.
private struct CreditKey: Hashable {

    let isMovie: Bool
    let id: Int

    init(_ credit: PersonCredit) {
        self.isMovie = credit.mediaType == .movie
        self.id = credit.id
    }

}
