//
//  TVSeriesImagesTool.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import FoundationModels
import TVSeriesDomain

/// A tool that provides image URLs for a specific TV series
public struct TVSeriesImagesTool: Tool {

    public let name = "getTVSeriesImages"
    public let description = "Get URLs for TV series posters and backdrops"

    @Generable
    public struct Arguments {
        @Guide(description: "Type of image: poster or backdrop")
        public var imageType: String

        public init(imageType: String = "poster") {
            self.imageType = imageType
        }
    }

    private let tvSeriesID: Int
    private let tvSeriesRepository: any TVSeriesRepository

    public init(tvSeriesID: Int, tvSeriesRepository: any TVSeriesRepository) {
        self.tvSeriesID = tvSeriesID
        self.tvSeriesRepository = tvSeriesRepository
    }

    public func call(arguments: Arguments) async throws -> String {
        let imageCollection = try await tvSeriesRepository.images(forTVSeries: tvSeriesID)

        switch arguments.imageType.lowercased() {
        case "poster":
            let urls = imageCollection.posterPaths.map(\.absoluteString)
            return urls.isEmpty ? "No posters available" : urls.joined(separator: "\n")

        case "backdrop":
            let urls = imageCollection.backdropPaths.map(\.absoluteString)
            return urls.isEmpty ? "No backdrops available" : urls.joined(separator: "\n")

        default:
            return "Unknown image type '\(arguments.imageType)'. Use 'poster' or 'backdrop'"
        }
    }

}
