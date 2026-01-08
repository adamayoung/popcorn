//
//  TVSeriesTool.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import FoundationModels
import IntelligenceDomain

///
/// LLM tool that fetches TV series details from the TV series provider
///
/// This tool enables the LLM to retrieve detailed information about TV series
/// including name and overview.
///
final class TVSeriesTool: Tool {

    private let tvSeriesProvider: any TVSeriesProviding

    let name = "fetchTVSeriesDetails"
    let description = "Fetch details about a TV series."

    init(tvSeriesProvider: some TVSeriesProviding) {
        self.tvSeriesProvider = tvSeriesProvider
    }

    @Generable
    struct Arguments {
        @Guide(description: "This is the ID of the TV series to fetch.")
        let tvSeriesID: Int
    }

    @Generable
    struct TVSeries: PromptRepresentable {
        @Guide(description: "This is the ID of the TV series.")
        let id: Int
        @Guide(description: "This is the name of the TV series.")
        let name: String
        @Guide(description: "This is the tagline of the TV series.")
        let tagline: String?
        @Guide(description: "This is an overview of the TV series.")
        let overview: String
        @Guide(description: "This is the number of seasons of the TV series.")
        let numberOfSeasons: Int
    }

    func call(arguments: Arguments) async throws -> TVSeries {
        let tvSeries = try await tvSeriesProvider.tvSeries(withID: arguments.tvSeriesID)
        let mapper = TVSeriesToolMapper()
        return mapper.map(tvSeries)
    }

}
