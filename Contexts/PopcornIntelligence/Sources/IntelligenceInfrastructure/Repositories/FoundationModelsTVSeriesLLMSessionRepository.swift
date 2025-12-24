//
//  FoundationModelsTVSeriesLLMSessionRepository.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import FoundationModels
import IntelligenceDomain
import Observability
import OSLog

// swiftlint:disable:next type_name
final class FoundationModelsTVSeriesLLMSessionRepository: TVSeriesLLMSessionRepository {

    private typealias FMLanguageModelSession = FoundationModels.LanguageModelSession

    private static let logger = Logger.intelligenceInfrastructure

    private let tvSeriesProvider: any TVSeriesProviding
    private let tvSeriesToolDataSource: any TVSeriesToolDataSource
//    private let observability: any Observing

    init(
        tvSeriesProvider: some TVSeriesProviding,
        tvSeriesToolDataSource: some TVSeriesToolDataSource
//        observability: some Observing
    ) {
        self.tvSeriesProvider = tvSeriesProvider
        self.tvSeriesToolDataSource = tvSeriesToolDataSource
//        self.observability = observability
    }

    func session(forTVSeries tvSeriesID: Int) async throws(TVSeriesLLMSessionRepositoryError) -> any LLMSession {
        let tvSeries: TVSeries
        do {
            tvSeries = try await tvSeriesProvider.tvSeries(withID: tvSeriesID)
        } catch let error {
            throw TVSeriesLLMSessionRepositoryError(error)
        }

        let tools: [any Tool] = [
            tvSeriesToolDataSource.tvSeriesDetails()
        ]

        let instructions = """
        You are a helpful TV series assistant. The user is viewing the TV series '\(tvSeries.name)' \
        and wants to learn more about it. Use the available tools to answer their questions \
        about the TV series' details.

        The TV series ID the user is viewing is \(tvSeries.id).
        The TV series name the user is viewing is '\(tvSeries.name)'.

        The focus of the conversation is the TV series '\(tvSeries.name)'.
        The conversation **MUST** focus on the TV series '\(tvSeries.name)'.

        Keep responses concise and focused on the information requested.

        You should have a pleasant nature and act like the movie's director.
        """

        let session = FMLanguageModelSession(
            tools: tools,
            instructions: instructions
        )

        let llmSession = FoundationModelsLLMSession(
            session: session
//            observability: observability
        )

        return llmSession
    }

}

extension TVSeriesLLMSessionRepositoryError {

    init(_ error: TVSeriesProviderError) {
        switch error {
        case .notFound: self = .tvSeriesNotFound
        case .unauthorised: self = .unknown()
        case .unknown(let error): self = .unknown(error)
        }
    }

}
