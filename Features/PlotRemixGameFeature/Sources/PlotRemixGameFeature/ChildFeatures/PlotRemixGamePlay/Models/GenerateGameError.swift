//
//  GenerateGameError.swift
//  PlotRemixGameFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PlotRemixGameApplication

enum GenerateGameError: LocalizedError {

    case riddleGeneration(Error? = nil)
    case unknown(Error? = nil)

    var errorDescription: String? {
        switch self {
        case .riddleGeneration:
            String(localized: "GAME_CANNOT_BE_GENERATED_ERROR_DESCRIPTION", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_DESCRIPTION", bundle: .module)
        }
    }

    var failureReason: String? {
        switch self {
        case .riddleGeneration:
            String(localized: "GAME_CANNOT_BE_GENERATED_ERROR_REASON", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_REASON", bundle: .module)
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .riddleGeneration:
            String(localized: "GAME_CANNOT_BE_GENERATED_ERROR_RECOVERY", bundle: .module)
        case .unknown:
            String(localized: "UNKNOWN_ERROR_RECOVERY", bundle: .module)
        }
    }

}

extension GenerateGameError {

    init(_ error: any Error) {
        if let generatePlotRemixGameError = error as? GeneratePlotRemixGameError {
            self.init(generatePlotRemixGameError)
            return
        }

        self = .unknown(error)
    }

    init(_ error: GeneratePlotRemixGameError) {
        switch error {
        case .riddleGeneration:
            self = .riddleGeneration(error)
        case .unauthorised:
            self = .unknown(error)
        case .unknown:
            self = .unknown(error)
        }
    }

}
