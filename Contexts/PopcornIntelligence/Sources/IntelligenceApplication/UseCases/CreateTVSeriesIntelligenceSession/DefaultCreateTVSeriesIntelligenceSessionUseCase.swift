//
//  DefaultCreateTVSeriesIntelligenceSessionUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain

final class DefaultCreateTVSeriesIntelligenceSessionUseCase: CreateTVSeriesIntelligenceSessionUseCase {

    private let tvSeriesSessionRepository: any TVSeriesLLMSessionRepository

    init(
        tvSeriesSessionRepository: some TVSeriesLLMSessionRepository
    ) {
        self.tvSeriesSessionRepository = tvSeriesSessionRepository
    }

    func execute(tvSeriesID: Int) async throws(CreateTVSeriesIntelligenceSessionError) -> any LLMSession {
        let session: any LLMSession
        do {
            session = try await tvSeriesSessionRepository.session(forTVSeries: tvSeriesID)
        } catch let error {
            throw CreateTVSeriesIntelligenceSessionError.sessionCreationFailed(error)
        }

        return session
    }

}
