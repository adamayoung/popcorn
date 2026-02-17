//
//  CreateMovieIntelligenceSessionError.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Errors that can occur during intelligence session operations
///
/// Represents the ``CreateMovieIntelligenceSessionError`` values.
public enum CreateMovieIntelligenceSessionError: Error {

    /// Failed to create an intelligence session
    case sessionCreationFailed(Error? = nil)

    case unknown(Error? = nil)

}
