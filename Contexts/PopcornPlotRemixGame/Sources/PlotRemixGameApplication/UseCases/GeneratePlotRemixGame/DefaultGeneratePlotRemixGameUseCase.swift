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

        let signpostID = Self.signposter.makeSignpostID()
        let interval = Self.signposter.beginInterval("Generating Plot Remix Game", id: signpostID)
        let questions: [GameQuestion]
        do {
            questions = try await withThrowingTaskGroup { taskGroup in
                for movie in movies {
                    taskGroup.addTask {
                        try await (
                            movie,
                            self.synopsisRiddleGenerator.riddle(for: movie, theme: config.theme)
                        )
                    }
                }

                var results: [GameQuestion] = []
                for try await (movie, riddle) in taskGroup {
                    Self.signposter.emitEvent("Question generated", id: signpostID)
                    let question = GameQuestion(movie: movie, riddle: riddle)
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
