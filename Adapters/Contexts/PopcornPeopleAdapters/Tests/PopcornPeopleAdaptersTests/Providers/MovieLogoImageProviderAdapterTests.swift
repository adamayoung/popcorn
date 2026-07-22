//
//  MovieLogoImageProviderAdapterTests.swift
//  PopcornPeopleAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesApplication
import PeopleDomain
@testable import PopcornPeopleAdapters
import Testing

@Suite("MovieLogoImageProviderAdapter Tests")
struct MovieLogoImageProviderAdapterTests {

    let mockUseCase: MockFetchMovieImageCollectionUseCase

    init() {
        self.mockUseCase = MockFetchMovieImageCollectionUseCase()
    }

    @Test("imageURLSet returns the first logo URL set")
    func imageURLSet_returnsFirstLogoURLSet() async throws {
        let firstLogo = try makeImageURLSet(path: "https://example.com/logo1.png")
        let secondLogo = try makeImageURLSet(path: "https://example.com/logo2.png")
        mockUseCase.executeStub = .success(
            ImageCollectionDetails(id: 1, posterURLSets: [], backdropURLSets: [], logoURLSets: [firstLogo, secondLogo])
        )

        let adapter = MovieLogoImageProviderAdapter(fetchImageCollectionUseCase: mockUseCase)

        let result = try await adapter.imageURLSet(forMovie: 1)

        #expect(result == firstLogo)
        #expect(mockUseCase.executeCallCount == 1)
        #expect(mockUseCase.executeCalledWith[0] == 1)
    }

    @Test("imageURLSet returns nil when there are no logos")
    func imageURLSet_returnsNilWhenNoLogos() async throws {
        mockUseCase.executeStub = .success(
            ImageCollectionDetails(id: 1, posterURLSets: [], backdropURLSets: [], logoURLSets: [])
        )

        let adapter = MovieLogoImageProviderAdapter(fetchImageCollectionUseCase: mockUseCase)

        let result = try await adapter.imageURLSet(forMovie: 1)

        #expect(result == nil)
    }

    @Test("imageURLSet translates a notFound error")
    func imageURLSet_translatesNotFound() async {
        mockUseCase.executeStub = .failure(.notFound)

        let adapter = MovieLogoImageProviderAdapter(fetchImageCollectionUseCase: mockUseCase)

        await #expect(
            performing: { try await adapter.imageURLSet(forMovie: 1) },
            throws: { error in
                guard let error = error as? MovieLogoImageProviderError else {
                    return false
                }
                if case .notFound = error {
                    return true
                }
                return false
            }
        )
    }

    private func makeImageURLSet(path: String) throws -> ImageURLSet {
        let url = try #require(URL(string: path))
        return ImageURLSet(path: url, thumbnail: url, card: url, detail: url, full: url)
    }

}
