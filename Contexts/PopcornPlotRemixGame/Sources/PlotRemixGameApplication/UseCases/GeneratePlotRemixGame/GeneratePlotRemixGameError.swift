//
//  GeneratePlotRemixGameError.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PlotRemixGameDomain

///
/// Errors that can occur during Plot Remix game generation.
///
/// These errors represent the various failure modes of the game generation process,
/// from authorization issues to AI riddle generation failures.
///
public enum GeneratePlotRemixGameError: Error {

    /// The request was not authorized to generate a game.
    case unauthorised

    /// The AI-powered riddle generation process failed.
    case riddleGeneration(Error?)

    /// An unknown error occurred during game generation.
    case unknown(Error?)

}

extension GeneratePlotRemixGameError {

    init(_ error: MovieProviderError) {
        switch error {
        case .unauthorised: self = .unauthorised
        case .unknown(let error): self = .unknown(error)
        }
    }

    init(_ error: SynopsisRiddleGeneratorError) {
        switch error {
        case .generation(let error): self = .riddleGeneration(error)
        case .unknown(let error): self = .unknown(error)
        }
    }

}
