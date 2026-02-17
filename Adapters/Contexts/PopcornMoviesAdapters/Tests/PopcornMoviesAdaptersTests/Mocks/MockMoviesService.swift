//
//  MockMoviesService.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

final class MockMoviesService: MovieService, @unchecked Sendable {

    struct DetailsCall: Equatable {
        let id: Int
        let language: String?
    }

    struct ImagesCall {
        let movieID: Int
        let filter: MovieImageFilter?
    }

    struct PopularCall: Equatable {
        let page: Int?
        let country: String?
        let language: String?
    }

    struct SimilarCall: Equatable {
        let movieID: Int
        let page: Int?
        let language: String?
    }

    struct RecommendationsCall: Equatable {
        let movieID: Int
        let page: Int?
        let language: String?
    }

    struct CreditsCall: Equatable {
        let movieID: Int
        let language: String?
    }

    struct ReleaseDatesCall: Equatable {
        let movieID: Int
    }

    var detailsCallCount = 0
    var detailsCalledWith: [DetailsCall] = []
    var detailsStub: Result<Movie, TMDbError>?

    var imagesCallCount = 0
    var imagesCalledWith: [ImagesCall] = []
    var imagesStub: Result<ImageCollection, TMDbError>?

    var popularCallCount = 0
    var popularCalledWith: [PopularCall] = []
    var popularStub: Result<MoviePageableList, TMDbError>?

    var similarCallCount = 0
    var similarCalledWith: [SimilarCall] = []
    var similarStub: Result<MoviePageableList, TMDbError>?

    var recommendationsCallCount = 0
    var recommendationsCalledWith: [RecommendationsCall] = []
    var recommendationsStub: Result<MoviePageableList, TMDbError>?

    var creditsCallCount = 0
    var creditsCalledWith: [CreditsCall] = []
    var creditsStub: Result<ShowCredits, TMDbError>?

    var releaseDatesCallCount = 0
    var releaseDatesCalledWith: [ReleaseDatesCall] = []
    var releaseDatesStub: Result<[MovieReleaseDatesByCountry], TMDbError>?

    func details(forMovie id: Movie.ID, language: String?) async throws -> Movie {
        detailsCallCount += 1
        detailsCalledWith.append(DetailsCall(id: id, language: language))

        guard let stub = detailsStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let movie):
            return movie
        case .failure(let error):
            throw error
        }
    }

    func details(
        forMovie id: Movie.ID,
        appending: MovieAppendOption,
        language: String?
    ) async throws -> MovieDetailsResponse {
        fatalError("Not implemented")
    }

    func credits(forMovie movieID: Movie.ID, language: String?) async throws -> ShowCredits {
        creditsCallCount += 1
        creditsCalledWith.append(CreditsCall(movieID: movieID, language: language))

        guard let stub = creditsStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let credits):
            return credits
        case .failure(let error):
            throw error
        }
    }

    func reviews(
        forMovie movieID: Movie.ID,
        page: Int?,
        language: String?
    ) async throws -> ReviewPageableList {
        fatalError("Not implemented")
    }

    func images(forMovie movieID: Movie.ID, filter: MovieImageFilter?) async throws -> ImageCollection {
        imagesCallCount += 1
        imagesCalledWith.append(ImagesCall(movieID: movieID, filter: filter))

        guard let stub = imagesStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let imageCollection):
            return imageCollection
        case .failure(let error):
            throw error
        }
    }

    func videos(forMovie movieID: Movie.ID, filter: MovieVideoFilter?) async throws -> VideoCollection {
        fatalError("Not implemented")
    }

    func recommendations(
        forMovie movieID: Movie.ID,
        page: Int?,
        language: String?
    ) async throws -> MoviePageableList {
        recommendationsCallCount += 1
        recommendationsCalledWith.append(RecommendationsCall(movieID: movieID, page: page, language: language))

        guard let stub = recommendationsStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let movies):
            return movies
        case .failure(let error):
            throw error
        }
    }

    func similar(toMovie movieID: Movie.ID, page: Int?, language: String?) async throws -> MoviePageableList {
        similarCallCount += 1
        similarCalledWith.append(SimilarCall(movieID: movieID, page: page, language: language))

        guard let stub = similarStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let movies):
            return movies
        case .failure(let error):
            throw error
        }
    }

    func nowPlaying(page: Int?, country: String?, language: String?) async throws -> MoviePageableList {
        fatalError("Not implemented")
    }

    func popular(page: Int?, country: String?, language: String?) async throws -> MoviePageableList {
        popularCallCount += 1
        popularCalledWith.append(PopularCall(page: page, country: country, language: language))

        guard let stub = popularStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let movies):
            return movies
        case .failure(let error):
            throw error
        }
    }

    func topRated(page: Int?, country: String?, language: String?) async throws -> MoviePageableList {
        fatalError("Not implemented")
    }

    func upcoming(page: Int?, country: String?, language: String?) async throws -> MoviePageableList {
        fatalError("Not implemented")
    }

    func watchProviders(forMovie movieID: Movie.ID) async throws -> [ShowWatchProvidersByCountry] {
        fatalError("Not implemented")
    }

    func externalLinks(forMovie movieID: Movie.ID) async throws -> MovieExternalLinksCollection {
        fatalError("Not implemented")
    }

    func releaseDates(forMovie movieID: Movie.ID) async throws -> [MovieReleaseDatesByCountry] {
        releaseDatesCallCount += 1
        releaseDatesCalledWith.append(ReleaseDatesCall(movieID: movieID))

        guard let stub = releaseDatesStub else {
            throw TMDbError.unknown
        }

        switch stub {
        case .success(let releaseDates):
            return releaseDates
        case .failure(let error):
            throw error
        }
    }

    func accountStates(forMovie movieID: Movie.ID, session: Session) async throws -> AccountStates {
        fatalError("Not implemented")
    }

    func addRating(_ rating: Double, toMovie movieID: Movie.ID, session: Session) async throws {
        fatalError("Not implemented")
    }

    func deleteRating(forMovie movieID: Movie.ID, session: Session) async throws {
        fatalError("Not implemented")
    }

    func alternativeTitles(
        forMovie movieID: Movie.ID,
        country: String?,
        language: String?
    ) async throws -> AlternativeTitleCollection {
        fatalError("Not implemented")
    }

    func translations(forMovie movieID: Movie.ID) async throws -> TranslationCollection<MovieTranslationData> {
        fatalError("Not implemented")
    }

    func lists(
        forMovie movieID: Movie.ID,
        page: Int?,
        language: String?
    ) async throws -> MediaListSummaryPageableList {
        fatalError("Not implemented")
    }

    func changes(
        forMovie movieID: Movie.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection {
        fatalError("Not implemented")
    }

    func latest() async throws -> Movie {
        fatalError("Not implemented")
    }

    func changes(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangedIDCollection {
        fatalError("Not implemented")
    }

    func keywords(forMovie movieID: Movie.ID) async throws -> KeywordCollection {
        fatalError("Not implemented")
    }

}
