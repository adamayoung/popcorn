//
//  CreateMovieIntelligenceSessionError.swift
//  PopcornIntelligence
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Errors that can occur during movie intelligence session creation.
///
public enum CreateMovieIntelligenceSessionError: Error {

    /// Failed to create an intelligence session for the movie.
    case sessionCreationFailed(Error? = nil)

    /// An unknown error occurred during session creation.
    case unknown(Error? = nil)

}
