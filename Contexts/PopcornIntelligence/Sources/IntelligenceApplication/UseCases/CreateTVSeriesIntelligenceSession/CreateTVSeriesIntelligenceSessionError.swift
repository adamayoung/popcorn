//
//  CreateTVSeriesIntelligenceSessionError.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Errors that can occur during TV series intelligence session operations
///
/// Represents the ``CreateTVSeriesIntelligenceSessionError`` values.
public enum CreateTVSeriesIntelligenceSessionError: Error {

    /// Failed to create an intelligence session
    case sessionCreationFailed(Error? = nil)

    case unknown(Error? = nil)

}
