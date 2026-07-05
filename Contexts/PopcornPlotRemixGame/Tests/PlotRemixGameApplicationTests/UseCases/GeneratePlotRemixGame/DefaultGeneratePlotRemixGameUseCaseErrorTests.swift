//
//  DefaultGeneratePlotRemixGameUseCaseErrorTests.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PlotRemixGameApplication
import PlotRemixGameDomain
import Testing

/// Covers translation of every `GeneratePlotRemixGameError` case.
///
/// The use case only ever produces `.unauthorised` / `.unknown` from the initial
/// `movieProvider.randomMovies` call. Any failure raised while concurrently generating
/// questions -- whether from the riddle generator or from `randomSimilarMovies` -- is
/// always wrapped as `.riddleGeneration`, regardless of the failure's original type.
/// These tests document that behaviour explicitly.
@Suite("DefaultGeneratePlotRemixGameUseCase error translation")
struct DefaultGeneratePlotRemixGameUseCaseErrorTests {

    let mockMovieProvider = MockMovieProviding()
    let mockGenreProvider = MockGenreProviding()
    let mockAppConfigurationProvider = MockAppConfigurationProviding()
    let mockSynopsisRiddleGenerator = MockSynopsisRiddleGenerating()

    @Test("execute throws unauthorised when randomMovies throws unauthorised")
    func executeThrowsUnauthorisedWhenRandomMoviesThrowsUnauthorised() async {
        mockMovieProvider.randomMoviesStub = .failure(.unauthorised)

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(config: .mock(), progress: { _ in })
            },
            throws: { error in
                guard let generateError = error as? GeneratePlotRemixGameError else {
                    return false
                }
                guard case .unauthorised = generateError else {
                    return false
                }
                return true
            }
        )
    }

    @Test("execute throws unknown when randomMovies throws unknown")
    func executeThrowsUnknownWhenRandomMoviesThrowsUnknown() async {
        mockMovieProvider.randomMoviesStub = .failure(.unknown(TestError()))

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(config: .mock(), progress: { _ in })
            },
            throws: { error in
                guard let generateError = error as? GeneratePlotRemixGameError else {
                    return false
                }
                guard case .unknown = generateError else {
                    return false
                }
                return true
            }
        )
    }

    @Test("execute throws riddleGeneration when the riddle generator throws a generation error")
    func executeThrowsRiddleGenerationWhenGeneratorThrowsGenerationError() async {
        mockMovieProvider.randomMoviesStub = .success([Movie.mock(id: 1)])
        mockMovieProvider.randomSimilarMoviesStub = .success([])
        mockSynopsisRiddleGenerator.riddleStub = .failure(.generation(TestError()))

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(config: .mock(), progress: { _ in })
            },
            throws: { error in
                guard let generateError = error as? GeneratePlotRemixGameError else {
                    return false
                }
                guard case .riddleGeneration(let underlying) = generateError else {
                    return false
                }
                return underlying is SynopsisRiddleGeneratorError
            }
        )
    }

    @Test("execute throws riddleGeneration when the riddle generator throws an unknown error")
    func executeThrowsRiddleGenerationWhenGeneratorThrowsUnknownError() async {
        mockMovieProvider.randomMoviesStub = .success([Movie.mock(id: 1)])
        mockMovieProvider.randomSimilarMoviesStub = .success([])
        mockSynopsisRiddleGenerator.riddleStub = .failure(.unknown(TestError()))

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(config: .mock(), progress: { _ in })
            },
            throws: { error in
                guard let generateError = error as? GeneratePlotRemixGameError else {
                    return false
                }
                guard case .riddleGeneration(let underlying) = generateError else {
                    return false
                }
                return underlying is SynopsisRiddleGeneratorError
            }
        )
    }

    @Test("execute throws riddleGeneration when randomSimilarMovies throws unauthorised")
    func executeThrowsRiddleGenerationWhenSimilarMoviesThrowsUnauthorised() async {
        mockMovieProvider.randomMoviesStub = .success([Movie.mock(id: 1)])
        mockMovieProvider.randomSimilarMoviesStub = .failure(.unauthorised)
        mockSynopsisRiddleGenerator.riddleStub = .success("A riddle")

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(config: .mock(), progress: { _ in })
            },
            throws: { error in
                guard let generateError = error as? GeneratePlotRemixGameError else {
                    return false
                }
                guard case .riddleGeneration(let underlying) = generateError else {
                    return false
                }
                return underlying is MovieProviderError
            }
        )
    }

    @Test("execute throws riddleGeneration when randomSimilarMovies throws unknown")
    func executeThrowsRiddleGenerationWhenSimilarMoviesThrowsUnknown() async {
        mockMovieProvider.randomMoviesStub = .success([Movie.mock(id: 1)])
        mockMovieProvider.randomSimilarMoviesStub = .failure(.unknown(TestError()))
        mockSynopsisRiddleGenerator.riddleStub = .success("A riddle")

        let useCase = makeUseCase()

        await #expect(
            performing: {
                try await useCase.execute(config: .mock(), progress: { _ in })
            },
            throws: { error in
                guard let generateError = error as? GeneratePlotRemixGameError else {
                    return false
                }
                guard case .riddleGeneration(let underlying) = generateError else {
                    return false
                }
                return underlying is MovieProviderError
            }
        )
    }

    // MARK: - Helpers

    private func makeUseCase() -> DefaultGeneratePlotRemixGameUseCase {
        DefaultGeneratePlotRemixGameUseCase(
            appConfigurationProvider: mockAppConfigurationProvider,
            movieProvider: mockMovieProvider,
            genreProvider: mockGenreProvider,
            synopsisRiddleGenerator: mockSynopsisRiddleGenerator
        )
    }

}

private struct TestError: Error {}
