//
//  DefaultCreateMovieIntelligenceSessionUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain

final class DefaultCreateMovieIntelligenceSessionUseCase: CreateMovieIntelligenceSessionUseCase {

    private let movieSessionRepository: any MovieLLMSessionRepository

    init(
        movieSessionRepository: some MovieLLMSessionRepository
    ) {
        self.movieSessionRepository = movieSessionRepository
    }

    func execute(movieID: Int) async throws(CreateMovieIntelligenceSessionError) -> any LLMSession {
        let session: any LLMSession
        do {
            session = try await movieSessionRepository.session(forMovie: movieID)
        } catch let error {
            throw CreateMovieIntelligenceSessionError.sessionCreationFailed(error)
        }

        return session
    }

}
