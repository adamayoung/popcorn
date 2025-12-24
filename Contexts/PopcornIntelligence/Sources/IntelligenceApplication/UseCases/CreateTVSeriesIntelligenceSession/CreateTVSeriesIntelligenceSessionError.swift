//
//  CreateTVSeriesIntelligenceSessionError.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Errors that can occur during TV series intelligence session operations
///
public enum CreateTVSeriesIntelligenceSessionError: Error {

    /// Failed to create an intelligence session
    case sessionCreationFailed(Error? = nil)

    case unknown(Error? = nil)

}
