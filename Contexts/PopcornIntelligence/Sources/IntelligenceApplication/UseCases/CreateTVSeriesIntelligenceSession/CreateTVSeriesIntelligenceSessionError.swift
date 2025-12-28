//
//  CreateTVSeriesIntelligenceSessionError.swift
//  PopcornIntelligence
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Errors that can occur during TV series intelligence session creation.
///
public enum CreateTVSeriesIntelligenceSessionError: Error {

    /// Failed to create an intelligence session for the TV series.
    case sessionCreationFailed(Error? = nil)

    /// An unknown error occurred during session creation.
    case unknown(Error? = nil)

}
