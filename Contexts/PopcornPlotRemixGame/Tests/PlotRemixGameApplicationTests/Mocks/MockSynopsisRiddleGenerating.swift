//
//  MockSynopsisRiddleGenerating.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PlotRemixGameDomain
import Synchronization

/// `riddle(for:theme:)` is invoked concurrently -- once per movie -- from
/// `DefaultGeneratePlotRemixGameUseCase`'s task group, so call-tracking state is kept behind
/// a `Mutex` to avoid data races across the concurrent child tasks.
final class MockSynopsisRiddleGenerating: SynopsisRiddleGenerating, @unchecked Sendable {

    struct RiddleCall: Equatable {
        let movieID: Int
        let theme: GameTheme
    }

    private struct CallState {
        var riddleCallCount = 0
        var riddleCalledWith: [RiddleCall] = []
    }

    private let callState = Mutex(CallState())

    var riddleStub: Result<String, SynopsisRiddleGeneratorError>?
    var riddleStubsByMovieID: [Int: Result<String, SynopsisRiddleGeneratorError>] = [:]

    var riddleCallCount: Int {
        callState.withLock { $0.riddleCallCount }
    }

    var riddleCalledWith: [RiddleCall] {
        callState.withLock { $0.riddleCalledWith }
    }

    func riddle(
        for movie: Movie,
        theme: GameTheme
    ) async throws(SynopsisRiddleGeneratorError) -> String {
        callState.withLock {
            $0.riddleCallCount += 1
            $0.riddleCalledWith.append(RiddleCall(movieID: movie.id, theme: theme))
        }

        if let stubForMovie = riddleStubsByMovieID[movie.id] {
            switch stubForMovie {
            case .success(let riddle):
                return riddle
            case .failure(let error):
                throw error
            }
        }

        guard let stub = riddleStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let riddle):
            return riddle
        case .failure(let error):
            throw error
        }
    }

}
