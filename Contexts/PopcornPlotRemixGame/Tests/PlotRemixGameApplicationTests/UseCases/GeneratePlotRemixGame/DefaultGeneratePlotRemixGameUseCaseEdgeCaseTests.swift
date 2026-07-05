//
//  DefaultGeneratePlotRemixGameUseCaseEdgeCaseTests.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PlotRemixGameApplication
import PlotRemixGameDomain
import Testing

@Suite("DefaultGeneratePlotRemixGameUseCase edge cases")
struct DefaultGeneratePlotRemixGameUseCaseEdgeCaseTests {

    let mockMovieProvider = MockMovieProviding()
    let mockGenreProvider = MockGenreProviding()
    let mockAppConfigurationProvider = MockAppConfigurationProviding()
    let mockSynopsisRiddleGenerator = MockSynopsisRiddleGenerating()

    // MARK: - Insufficient Input

    @Test("execute returns an empty game and reports only the initial progress when there are no movies")
    func executeReturnsEmptyGameWhenNoMoviesReturned() async throws {
        mockMovieProvider.randomMoviesStub = .success([])

        let useCase = makeUseCase()
        let recorder = ProgressRecorder()

        let game = try await useCase.execute(config: .mock(), progress: { recorder.append($0) })

        #expect(game.questions.isEmpty)
        #expect(recorder.values == [0])
    }

    @Test("execute produces fewer answer options when the provider returns fewer similar movies than configured")
    func executeProducesFewerOptionsWithFewerSimilarMovies() async throws {
        mockMovieProvider.randomMoviesStub = .success([Movie.mock(id: 1)])
        mockMovieProvider.randomSimilarMoviesStub = .success([Movie.mock(id: 2)])
        mockSynopsisRiddleGenerator.riddleStub = .success("A riddle")

        let useCase = makeUseCase()

        let game = try await useCase.execute(config: .mock(), progress: { _ in })

        #expect(game.questions.first?.options.count == 2)
    }

    @Test("execute produces only the correct answer when the provider returns no similar movies")
    func executeProducesOnlyCorrectAnswerWithNoSimilarMovies() async throws {
        mockMovieProvider.randomMoviesStub = .success([Movie.mock(id: 1)])
        mockMovieProvider.randomSimilarMoviesStub = .success([])
        mockSynopsisRiddleGenerator.riddleStub = .success("A riddle")

        let useCase = makeUseCase()

        let game = try await useCase.execute(config: .mock(), progress: { _ in })

        let question = try #require(game.questions.first)

        #expect(question.options.count == 1)
        #expect(question.options.first?.isCorrect == true)
    }

    // MARK: - Progress Reporting

    @Test("execute always reports zero as the first progress value")
    func executeReportsZeroFirst() async throws {
        mockMovieProvider.randomMoviesStub = .success([Movie.mock(id: 1), Movie.mock(id: 2)])
        mockMovieProvider.randomSimilarMoviesStub = .success([])
        mockSynopsisRiddleGenerator.riddleStub = .success("A riddle")

        let useCase = makeUseCase()
        let recorder = ProgressRecorder()

        _ = try await useCase.execute(config: .mock(), progress: { recorder.append($0) })

        #expect(recorder.values.first == 0)
    }

    @Test("execute reports one progress value per generated question plus the initial zero")
    func executeReportsOneProgressValuePerQuestionPlusInitial() async throws {
        let movies = (1 ... 3).map { Movie.mock(id: $0) }
        mockMovieProvider.randomMoviesStub = .success(movies)
        mockMovieProvider.randomSimilarMoviesStub = .success([])
        mockSynopsisRiddleGenerator.riddleStub = .success("A riddle")

        let useCase = makeUseCase()
        let recorder = ProgressRecorder()

        _ = try await useCase.execute(config: .mock(), progress: { recorder.append($0) })

        #expect(recorder.values.count == 4)
    }

    @Test("execute never reaches full progress when fewer movies are returned than the configured question count")
    func executeNeverReachesFullProgressWithFewerMovies() async throws {
        let movies = (1 ... 3).map { Movie.mock(id: $0) }
        mockMovieProvider.randomMoviesStub = .success(movies)
        mockMovieProvider.randomSimilarMoviesStub = .success([])
        mockSynopsisRiddleGenerator.riddleStub = .success("A riddle")

        let useCase = makeUseCase()
        let recorder = ProgressRecorder()

        _ = try await useCase.execute(config: .mock(), progress: { recorder.append($0) })

        let maxProgress = try #require(recorder.values.max())
        #expect(maxProgress < 1.0)
    }

    @Test("execute caps progress at 1.0 once the movie count reaches the configured question count")
    func executeCapsProgressAtOneWhenMovieCountReachesQuestionCount() async throws {
        let movies = (1 ... 10).map { Movie.mock(id: $0) }
        mockMovieProvider.randomMoviesStub = .success(movies)
        mockMovieProvider.randomSimilarMoviesStub = .success([])
        mockSynopsisRiddleGenerator.riddleStub = .success("A riddle")

        let useCase = makeUseCase()
        let recorder = ProgressRecorder()

        _ = try await useCase.execute(config: .mock(), progress: { recorder.append($0) })

        #expect(recorder.values.count == 11)
        #expect(recorder.values.max() == 1.0)
        #expect(recorder.values.allSatisfy { $0 <= 1.0 })
    }

    // MARK: - Unused Dependencies

    /// `appConfigurationProvider` and `genreProvider` are accepted by the initializer but
    /// never invoked by `execute` -- the genre used in `Game.Settings` is currently hardcoded.
    /// This test documents that characteristic so a future change is a deliberate decision.
    @Test("execute never calls the unused genre or app configuration providers")
    func executeNeverCallsUnusedProviders() async throws {
        mockMovieProvider.randomMoviesStub = .success([Movie.mock(id: 1)])
        mockMovieProvider.randomSimilarMoviesStub = .success([])
        mockSynopsisRiddleGenerator.riddleStub = .success("A riddle")

        let useCase = makeUseCase()

        _ = try await useCase.execute(config: .mock(), progress: { _ in })

        #expect(mockGenreProvider.moviesCallCount == 0)
        #expect(mockAppConfigurationProvider.appConfigurationCallCount == 0)
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
