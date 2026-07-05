//
//  DefaultGeneratePlotRemixGameUseCaseTests.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PlotRemixGameApplication
import PlotRemixGameDomain
import Testing

@Suite("DefaultGeneratePlotRemixGameUseCase")
struct DefaultGeneratePlotRemixGameUseCaseTests {

    let mockMovieProvider = MockMovieProviding()
    let mockGenreProvider = MockGenreProviding()
    let mockAppConfigurationProvider = MockAppConfigurationProviding()
    let mockSynopsisRiddleGenerator = MockSynopsisRiddleGenerating()

    // MARK: - Question Generation

    @Test("execute returns a game with one question per movie returned by the provider")
    func executeReturnsGameWithQuestionCountMatchingMovies() async throws {
        let movies = [Movie.mock(id: 1, title: "Movie One"), Movie.mock(id: 2, title: "Movie Two")]
        mockMovieProvider.randomMoviesStub = .success(movies)
        mockMovieProvider.randomSimilarMoviesStub = .success([Movie.mock(id: 100, title: "Similar")])
        mockSynopsisRiddleGenerator.riddleStub = .success("A riddle")

        let useCase = makeUseCase()

        let game = try await useCase.execute(config: .mock(), progress: { _ in })

        #expect(game.questions.count == 2)
    }

    @Test("execute builds each question with exactly one correct answer matching its movie")
    func executeBuildsExactlyOneCorrectAnswerPerQuestion() async throws {
        let movie = Movie.mock(id: 42, title: "The Movie")
        mockMovieProvider.randomMoviesStub = .success([movie])
        mockMovieProvider.randomSimilarMoviesStub = .success([Movie.mock(id: 1, title: "Other")])
        mockSynopsisRiddleGenerator.riddleStub = .success("A riddle")

        let useCase = makeUseCase()

        let game = try await useCase.execute(config: .mock(), progress: { _ in })

        let question = try #require(game.questions.first)
        let correctOptions = question.options.filter(\.isCorrect)

        #expect(correctOptions.count == 1)
        #expect(correctOptions.first?.id == 42)
        #expect(correctOptions.first?.title == "The Movie")
    }

    @Test("execute builds incorrect answer options from the similar movies returned by the provider")
    func executeBuildsIncorrectAnswersFromSimilarMovies() async throws {
        let movie = Movie.mock(id: 42, title: "The Movie")
        let similarMovies = [
            Movie.mock(id: 1, title: "Alpha"), Movie.mock(id: 2, title: "Beta"), Movie.mock(id: 3, title: "Gamma")
        ]
        mockMovieProvider.randomMoviesStub = .success([movie])
        mockMovieProvider.randomSimilarMoviesStub = .success(similarMovies)
        mockSynopsisRiddleGenerator.riddleStub = .success("A riddle")

        let useCase = makeUseCase()

        let game = try await useCase.execute(config: .mock(), progress: { _ in })

        let question = try #require(game.questions.first)
        let incorrectOptions = question.options.filter { !$0.isCorrect }

        #expect(incorrectOptions.count == 3)
        #expect(Set(incorrectOptions.map(\.id)) == Set([1, 2, 3]))
    }

    @Test("execute generates a unique game id for every call")
    func executeGeneratesUniqueGameIDPerCall() async throws {
        mockMovieProvider.randomMoviesStub = .success([Movie.mock()])
        mockMovieProvider.randomSimilarMoviesStub = .success([])
        mockSynopsisRiddleGenerator.riddleStub = .success("A riddle")

        let useCase = makeUseCase()

        let first = try await useCase.execute(config: .mock(), progress: { _ in })
        let second = try await useCase.execute(config: .mock(), progress: { _ in })

        #expect(first.id != second.id)
    }

    // MARK: - Settings

    @Test("execute uses the theme from config in the game settings")
    func executeUsesThemeFromConfig() async throws {
        mockMovieProvider.randomMoviesStub = .success([Movie.mock()])
        mockMovieProvider.randomSimilarMoviesStub = .success([])
        mockSynopsisRiddleGenerator.riddleStub = .success("A riddle")

        let useCase = makeUseCase()

        let game = try await useCase.execute(config: .mock(theme: .noir), progress: { _ in })

        #expect(game.settings.theme == .noir)
    }

    @Test("execute always uses the hardcoded Action genre in settings, ignoring config.genreID")
    func executeAlwaysUsesHardcodedActionGenre() async throws {
        mockMovieProvider.randomMoviesStub = .success([Movie.mock()])
        mockMovieProvider.randomSimilarMoviesStub = .success([])
        mockSynopsisRiddleGenerator.riddleStub = .success("A riddle")

        let useCase = makeUseCase()

        // genreID 35 (Comedy) is currently ignored by the use case's genre selection.
        let game = try await useCase.execute(config: .mock(genreID: 35), progress: { _ in })

        #expect(game.settings.genre == Genre(id: 28, name: "Action"))
    }

    @Test("execute reflects a custom primaryReleaseYearFilter from config in settings")
    func executeReflectsCustomPrimaryReleaseYear() async throws {
        mockMovieProvider.randomMoviesStub = .success([Movie.mock()])
        mockMovieProvider.randomSimilarMoviesStub = .success([])
        mockSynopsisRiddleGenerator.riddleStub = .success("A riddle")

        let useCase = makeUseCase()
        let config = GameConfig.mock(primaryReleaseYearFilter: .onYear(1999))

        let game = try await useCase.execute(config: config, progress: { _ in })

        #expect(game.settings.primaryReleaseYear == .onYear(1999))
    }

    @Test("execute defaults primaryReleaseYear in settings to 1980 through 2025 when config omits it")
    func executeDefaultsPrimaryReleaseYearWhenConfigOmitsIt() async throws {
        mockMovieProvider.randomMoviesStub = .success([Movie.mock()])
        mockMovieProvider.randomSimilarMoviesStub = .success([])
        mockSynopsisRiddleGenerator.riddleStub = .success("A riddle")

        let useCase = makeUseCase()
        let config = GameConfig.mock(primaryReleaseYearFilter: nil)

        let game = try await useCase.execute(config: config, progress: { _ in })

        #expect(game.settings.primaryReleaseYear == .betweenYears(start: 1980, end: 2025))
    }

    // MARK: - Dependency Wiring

    @Test("execute requests exactly ten random movies from the provider")
    func executeRequestsTenRandomMovies() async throws {
        mockMovieProvider.randomMoviesStub = .success([])

        let useCase = makeUseCase()

        _ = try await useCase.execute(config: .mock(), progress: { _ in })

        #expect(mockMovieProvider.randomMoviesCallCount == 1)
        #expect(mockMovieProvider.randomMoviesCalledWith.first?.limit == 10)
    }

    @Test("execute requests similar movies with a limit of three for every returned movie")
    func executeRequestsSimilarMoviesWithLimitThree() async throws {
        let movies = [Movie.mock(id: 1), Movie.mock(id: 2), Movie.mock(id: 3)]
        mockMovieProvider.randomMoviesStub = .success(movies)
        mockMovieProvider.randomSimilarMoviesStub = .success([])
        mockSynopsisRiddleGenerator.riddleStub = .success("A riddle")

        let useCase = makeUseCase()

        _ = try await useCase.execute(config: .mock(), progress: { _ in })

        #expect(mockMovieProvider.randomSimilarMoviesCallCount == 3)
        #expect(Set(mockMovieProvider.randomSimilarMoviesCalledWith.map(\.movieID)) == Set([1, 2, 3]))
        #expect(mockMovieProvider.randomSimilarMoviesCalledWith.allSatisfy { $0.limit == 3 })
    }

    @Test("execute requests a riddle using each movie and the config theme")
    func executeRequestsRiddleWithMovieAndTheme() async throws {
        let movies = [Movie.mock(id: 1), Movie.mock(id: 2)]
        mockMovieProvider.randomMoviesStub = .success(movies)
        mockMovieProvider.randomSimilarMoviesStub = .success([])
        mockSynopsisRiddleGenerator.riddleStub = .success("A riddle")

        let useCase = makeUseCase()

        _ = try await useCase.execute(config: .mock(theme: .mythic), progress: { _ in })

        #expect(mockSynopsisRiddleGenerator.riddleCallCount == 2)
        #expect(Set(mockSynopsisRiddleGenerator.riddleCalledWith.map(\.movieID)) == Set([1, 2]))
        #expect(mockSynopsisRiddleGenerator.riddleCalledWith.allSatisfy { $0.theme == .mythic })
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
