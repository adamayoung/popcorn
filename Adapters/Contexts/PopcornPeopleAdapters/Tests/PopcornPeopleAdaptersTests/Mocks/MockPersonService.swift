//
//  MockPersonService.swift
//  PopcornPeopleAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

final class MockPersonService: PersonService, @unchecked Sendable {

    struct DetailsCall: Equatable {
        let id: Int
        let language: String?
    }

    struct CombinedCreditsCall: Equatable {
        let personID: Int
        let language: String?
    }

    struct MovieCreditsCall: Equatable {
        let personID: Int
        let language: String?
    }

    struct TVSeriesCreditsCall: Equatable {
        let personID: Int
        let language: String?
    }

    struct ImagesCall: Equatable {
        let personID: Int
    }

    struct PopularCall: Equatable {
        let page: Int?
        let language: String?
    }

    struct ExternalLinksCall: Equatable {
        let personID: Int
    }

    var detailsCallCount = 0
    var detailsCalledWith: [DetailsCall] = []
    var detailsStub: Result<TMDb.Person, TMDbError>?

    var combinedCreditsCallCount = 0
    var combinedCreditsCalledWith: [CombinedCreditsCall] = []
    var combinedCreditsStub: Result<PersonCombinedCredits, TMDbError>?

    var movieCreditsCallCount = 0
    var movieCreditsCalledWith: [MovieCreditsCall] = []
    var movieCreditsStub: Result<PersonMovieCredits, TMDbError>?

    var tvSeriesCreditsCallCount = 0
    var tvSeriesCreditsCalledWith: [TVSeriesCreditsCall] = []
    var tvSeriesCreditsStub: Result<PersonTVSeriesCredits, TMDbError>?

    var imagesCallCount = 0
    var imagesCalledWith: [ImagesCall] = []
    var imagesStub: Result<PersonImageCollection, TMDbError>?

    var popularCallCount = 0
    var popularCalledWith: [PopularCall] = []
    var popularStub: Result<PersonPageableList, TMDbError>?

    var externalLinksCallCount = 0
    var externalLinksCalledWith: [ExternalLinksCall] = []
    var externalLinksStub: Result<PersonExternalLinksCollection, TMDbError>?

    func details(forPerson id: TMDb.Person.ID, language: String?) async throws -> TMDb.Person {
        detailsCallCount += 1
        detailsCalledWith.append(DetailsCall(id: id, language: language))

        guard let stub = detailsStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let person):
            return person
        case .failure(let error):
            throw error
        }
    }

    func combinedCredits(
        forPerson personID: TMDb.Person.ID,
        language: String?
    ) async throws -> PersonCombinedCredits {
        combinedCreditsCallCount += 1
        combinedCreditsCalledWith.append(CombinedCreditsCall(personID: personID, language: language))

        guard let stub = combinedCreditsStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let credits):
            return credits
        case .failure(let error):
            throw error
        }
    }

    func movieCredits(
        forPerson personID: TMDb.Person.ID,
        language: String?
    ) async throws -> PersonMovieCredits {
        movieCreditsCallCount += 1
        movieCreditsCalledWith.append(MovieCreditsCall(personID: personID, language: language))

        guard let stub = movieCreditsStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let credits):
            return credits
        case .failure(let error):
            throw error
        }
    }

    func tvSeriesCredits(
        forPerson personID: TMDb.Person.ID,
        language: String?
    ) async throws -> PersonTVSeriesCredits {
        tvSeriesCreditsCallCount += 1
        tvSeriesCreditsCalledWith.append(TVSeriesCreditsCall(personID: personID, language: language))

        guard let stub = tvSeriesCreditsStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let credits):
            return credits
        case .failure(let error):
            throw error
        }
    }

    func images(forPerson personID: TMDb.Person.ID) async throws -> PersonImageCollection {
        imagesCallCount += 1
        imagesCalledWith.append(ImagesCall(personID: personID))

        guard let stub = imagesStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let images):
            return images
        case .failure(let error):
            throw error
        }
    }

    func popular(page: Int?, language: String?) async throws -> PersonPageableList {
        popularCallCount += 1
        popularCalledWith.append(PopularCall(page: page, language: language))

        guard let stub = popularStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let list):
            return list
        case .failure(let error):
            throw error
        }
    }

    func externalLinks(forPerson personID: TMDb.Person.ID) async throws -> PersonExternalLinksCollection {
        externalLinksCallCount += 1
        externalLinksCalledWith.append(ExternalLinksCall(personID: personID))

        guard let stub = externalLinksStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let links):
            return links
        case .failure(let error):
            throw error
        }
    }

    func details(
        forPerson id: TMDb.Person.ID,
        appending: PersonAppendOption,
        language: String?
    ) async throws -> PersonDetailsResponse {
        fatalError("Not implemented")
    }

    func taggedImages(
        forPerson personID: TMDb.Person.ID,
        page: Int?
    ) async throws -> TaggedImagePageableList {
        fatalError("Not implemented")
    }

    func translations(
        forPerson personID: TMDb.Person.ID
    ) async throws -> TranslationCollection<PersonTranslationData> {
        fatalError("Not implemented")
    }

    func changes(
        forPerson personID: TMDb.Person.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection {
        fatalError("Not implemented")
    }

    func latestPerson() async throws -> TMDb.Person {
        fatalError("Not implemented")
    }

    func personChanges(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangedIDCollection {
        fatalError("Not implemented")
    }

}
