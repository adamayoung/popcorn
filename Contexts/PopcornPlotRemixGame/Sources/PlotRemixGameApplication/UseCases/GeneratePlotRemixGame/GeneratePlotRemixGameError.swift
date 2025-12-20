//
//  GeneratePlotRemixGameError.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PlotRemixGameDomain

public enum GeneratePlotRemixGameError: Error {

    case unauthorised
    case riddleGeneration(Error?)
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
