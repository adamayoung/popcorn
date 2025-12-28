//
//  DefaultCreateTVSeriesIntelligenceSessionUseCase.swift
//  PopcornIntelligence
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain

// swiftlint:disable:next type_name
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
