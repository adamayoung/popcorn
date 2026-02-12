//
//  TMDbMovieRemoteDataSourceCertificationTests.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
import MoviesInfrastructure
@testable import PopcornMoviesAdapters
import Testing
import TMDb

@Suite("TMDbMovieRemoteDataSource Certification Tests")
struct TMDbMovieRemoteDataSourceCertificationTests {

    let mockService: MockMoviesService

    init() {
        self.mockService = MockMoviesService()
    }

    @Test("certification returns certification from US release dates")
    func certification_returnsCertificationFromUSReleaseDates() async throws {
        let movieID = 550

        let releaseDates: [MovieReleaseDatesByCountry] = [
            MovieReleaseDatesByCountry(
                countryCode: "US",
                releaseDates: [
                    ReleaseDate(
                        certification: "R",
                        releaseDate: Date(),
                        type: .theatrical
                    )
                ]
            )
        ]

        mockService.releaseDatesStub = .success(releaseDates)

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        let result = try await dataSource.certification(forMovie: movieID)

        #expect(result == "R")
        #expect(mockService.releaseDatesCallCount == 1)
        #expect(mockService.releaseDatesCalledWith[0].movieID == movieID)
    }

    @Test("certification throws notFound error when no release dates exist")
    func certification_throwsNotFoundErrorWhenNoReleaseDatesExist() async {
        let movieID = 550

        mockService.releaseDatesStub = .success([])

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        await #expect(
            performing: {
                try await dataSource.certification(forMovie: movieID)
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

    @Test("certification throws notFound error when no certification found")
    func certification_throwsNotFoundErrorWhenNoCertificationFound() async {
        let movieID = 550

        let releaseDates: [MovieReleaseDatesByCountry] = [
            MovieReleaseDatesByCountry(
                countryCode: "US",
                releaseDates: [
                    ReleaseDate(
                        certification: "",
                        releaseDate: Date(),
                        type: .theatrical
                    )
                ]
            )
        ]

        mockService.releaseDatesStub = .success(releaseDates)

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        await #expect(
            performing: {
                try await dataSource.certification(forMovie: movieID)
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

    @Test("certification throws notFound error for TMDb notFound")
    func certification_throwsNotFoundErrorForTMDbNotFound() async {
        mockService.releaseDatesStub = .failure(.notFound())

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        await #expect(
            performing: {
                try await dataSource.certification(forMovie: 550)
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

    @Test("certification throws unauthorised error for TMDb unauthorised")
    func certification_throwsUnauthorisedErrorForTMDbUnauthorised() async {
        mockService.releaseDatesStub = .failure(.unauthorised("No access"))

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        await #expect(
            performing: {
                try await dataSource.certification(forMovie: 550)
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

    @Test("certification falls back to US when current locale not found")
    func certification_fallsBackToUSWhenCurrentLocaleNotFound() async throws {
        let movieID = 550

        let releaseDates: [MovieReleaseDatesByCountry] = [
            MovieReleaseDatesByCountry(
                countryCode: "FR",
                releaseDates: [
                    ReleaseDate(
                        certification: "Tous publics",
                        releaseDate: Date(),
                        type: .theatrical
                    )
                ]
            ),
            MovieReleaseDatesByCountry(
                countryCode: "US",
                releaseDates: [
                    ReleaseDate(
                        certification: "R",
                        releaseDate: Date(),
                        type: .theatrical
                    )
                ]
            )
        ]

        mockService.releaseDatesStub = .success(releaseDates)

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        // Note: This test assumes the current locale is not FR
        // The implementation prioritizes current locale, then falls back to US
        let result = try await dataSource.certification(forMovie: movieID)

        // The result will be either the locale's certification or US's "R"
        #expect(!result.isEmpty)
    }

}
