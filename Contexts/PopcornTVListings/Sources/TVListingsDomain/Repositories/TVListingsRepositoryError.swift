//
//  TVListingsRepositoryError.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Errors that can occur when accessing TV-listings data through a repository.
///
public enum TVListingsRepositoryError: Error {

    /// The remote data source failed (network, server, decoding).
    case remote(Error?)

    /// The local persistence layer failed.
    case local(Error?)

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error?)

}
