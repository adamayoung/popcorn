//
//  TMDbMovieRemoteDataSourceCreditsTests.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
import MoviesInfrastructure
@testable import PopcornMoviesAdapters
import Testing
import TMDb

@Suite("TMDbMovieRemoteDataSource Credits Tests")
struct TMDbMovieRemoteDataSourceCreditsTests {

    let mockService: MockMoviesService

    init() {
        self.mockService = MockMoviesService()
    }

    @Test("credits maps response correctly")
    func credits_mapsResponseCorrectly() async throws {
        let movieID = 550

        let tmdbCredits = ShowCredits(
            id: movieID,
            cast: [
                CastMember(
                    id: 819,
                    creditID: "credit1",
                    name: "Edward Norton",
                    character: "The Narrator",
                    gender: .male,
                    profilePath: nil,
                    order: 0
                )
            ],
            crew: [
                CrewMember(
                    id: 7467,
                    creditID: "credit2",
                    name: "David Fincher",
                    job: "Director",
                    department: "Directing",
                    gender: .male,
                    profilePath: nil
                )
            ]
        )

        mockService.creditsStub = .success(tmdbCredits)

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        let result = try await dataSource.credits(forMovie: movieID)

        #expect(result.id == movieID)
        #expect(result.cast.count == 1)
        #expect(result.cast[0].personName == "Edward Norton")
        #expect(result.crew.count == 1)
        #expect(result.crew[0].personName == "David Fincher")
        #expect(mockService.creditsCallCount == 1)
        #expect(mockService.creditsCalledWith[0].movieID == movieID)
    }

    @Test("credits throws notFound error for TMDb notFound")
    func credits_throwsNotFoundErrorForTMDbNotFound() async {
        mockService.creditsStub = .failure(.notFound())

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        await #expect(
            performing: {
                try await dataSource.credits(forMovie: 550)
            },
            throws: { error in
                guard let error = error as? MovieRemoteDataSourceError else {
                    return false
                }

                if case .notFound = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("credits throws unauthorised error for TMDb unauthorised")
    func credits_throwsUnauthorisedErrorForTMDbUnauthorised() async {
        mockService.creditsStub = .failure(.unauthorised("No access"))

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        await #expect(
            performing: {
                try await dataSource.credits(forMovie: 550)
            },
            throws: { error in
                guard let error = error as? MovieRemoteDataSourceError else {
                    return false
                }

                if case .unauthorised = error {
                    return true
                }

                return false
            }
        )
    }

}
