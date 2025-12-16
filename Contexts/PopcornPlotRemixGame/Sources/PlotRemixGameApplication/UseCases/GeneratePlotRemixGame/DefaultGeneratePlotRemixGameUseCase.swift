//
//  GeneratePlotRemixGameUseCase.swift
//  PopcornPlotRemixGame
//
//  Created by Adam Young on 05/12/2025.
//

import Foundation
import OSLog
import PlotRemixGameDomain

final class DefaultGeneratePlotRemixGameUseCase: GeneratePlotRemixGameUseCase {

    private static let logger = Logger(
        subsystem: "PopcornPlotRemixGame",
        category: "DefaultGeneratePlotRemixGameUseCase"
    )
    private static let signposter = OSSignposter(logger: logger)

    private static let questionCount = 10
    private static let answersCount = 4

    private let appConfigurationProvider: any AppConfigurationProviding
    private let movieProvider: any MovieProviding
    private let genreProvider: any GenreProviding
    private let synopsisRiddleGenerator: any SynopsisRiddleGenerating

    public init(
        appConfigurationProvider: some AppConfigurationProviding,
        movieProvider: some MovieProviding,
        genreProvider: some GenreProviding,
        synopsisRiddleGenerator: SynopsisRiddleGenerating
    ) {
        self.appConfigurationProvider = appConfigurationProvider
        self.movieProvider = movieProvider
        self.genreProvider = genreProvider
        self.synopsisRiddleGenerator = synopsisRiddleGenerator
    }

    func execute(
        config: GameConfig,
        progress: @Sendable @escaping (Float) -> Void
    ) async throws(GeneratePlotRemixGameError) -> Game {
        progress(0)

        let filter = MovieFilter(config: config)
        let genre = Genre(id: 28, name: "Action")

        let movies: [Movie]
        do {
            movies = try await movieProvider.randomMovies(filter: filter, limit: Self.questionCount)
        } catch let error {
            throw GeneratePlotRemixGameError(error)
        }

        Self.logger.trace("Generating Plot Remix Game with \(movies.count) movies")
        let signpostID = Self.signposter.makeSignpostID()
        let interval = Self.signposter.beginInterval("Generating Plot Remix Game", id: signpostID)
        let questions: [GameQuestion]
        do {
            questions = try await withThrowingTaskGroup { taskGroup in
                for movie in movies {
                    taskGroup.addTask {
                        async let riddle = self.synopsisRiddleGenerator.riddle(
                            for: movie,
                            theme: config.theme
                        )
                        async let similarMovies = self.movieProvider.randomSimilarMovies(
                            to: movie.id,
                            limit: Self.answersCount - 1
                        )

                        return try await (movie, riddle, similarMovies)
                    }
                }

                var results: [GameQuestion] = []
                for try await (movie, riddle, similarMovies) in taskGroup {
                    Self.logger.trace("Riddle generated for '\(movie.title)'")
                    Self.signposter.emitEvent("Riddle generated", id: signpostID)

                    let correctAnswer = AnswerOption(
                        id: movie.id, title: movie.title, isCorrect: true)
                    let incorrectAnswers = similarMovies.map { movie in
                        AnswerOption(id: movie.id, title: movie.title, isCorrect: false)
                    }

                    let options = ([correctAnswer] + incorrectAnswers).shuffled()

                    let question = GameQuestion(movie: movie, riddle: riddle, options: options)
                    results.append(question)

                    let progressValue = min(
                        Float(results.count + 1) / Float(Self.questionCount), 1.0)
                    progress(progressValue)
                }

                return results
            }
        } catch let error {
            Self.signposter.endInterval(
                "Generating Plot Remix Game", interval,
                "\(error.localizedDescription, privacy: .public)")
            throw .riddleGeneration(error)
        }
        Self.signposter.endInterval("Generating Plot Remix Game", interval)

        let game = Game(
            id: UUID(),
            settings: Game.Settings(
                theme: config.theme,
                genre: genre,
                primaryReleaseYear: filter.primaryReleaseYear
            ),
            questions: questions
        )

        return game
    }

}
