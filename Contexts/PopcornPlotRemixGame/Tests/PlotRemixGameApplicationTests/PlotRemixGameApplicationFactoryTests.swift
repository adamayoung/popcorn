//
//  PlotRemixGameApplicationFactoryTests.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PlotRemixGameApplication
import PlotRemixGameDomain
import Testing

@Suite("PlotRemixGameApplicationFactory")
struct PlotRemixGameApplicationFactoryTests {

    @Test("makeGeneratePlotRemixGameUseCase wires dependencies into a working use case")
    func makeGeneratePlotRemixGameUseCaseWiresDependencies() async throws {
        let mockMovieProvider = MockMovieProviding()
        let mockGenreProvider = MockGenreProviding()
        let mockAppConfigurationProvider = MockAppConfigurationProviding()
        let mockSynopsisRiddleGenerator = MockSynopsisRiddleGenerating()

        mockMovieProvider.randomMoviesStub = .success([Movie.mock(id: 1)])
        mockMovieProvider.randomSimilarMoviesStub = .success([])
        mockSynopsisRiddleGenerator.riddleStub = .success("A riddle")

        let factory = PlotRemixGameApplicationFactory(
            appConfigurationProvider: mockAppConfigurationProvider,
            movieProvider: mockMovieProvider,
            genreProvider: mockGenreProvider,
            synopsisRiddleGenerator: mockSynopsisRiddleGenerator
        )

        let useCase = factory.makeGeneratePlotRemixGameUseCase()

        let game = try await useCase.execute(config: .mock(), progress: { _ in })

        #expect(game.questions.count == 1)
        #expect(mockMovieProvider.randomMoviesCallCount == 1)
    }

}
