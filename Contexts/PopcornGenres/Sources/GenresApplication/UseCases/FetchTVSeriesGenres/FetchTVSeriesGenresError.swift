//
//  FetchTVSeriesGenresError.swift
//  PopcornGenres
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresDomain

public enum FetchTVSeriesGenresError: Error {

    case unauthorised
    case unknown(Error? = nil)

}

extension FetchTVSeriesGenresError {

    init(_ error: GenreRepositoryError) {
        switch error {
        case .cacheUnavailable: self = .unknown(nil)
        case .unauthorised: self = .unauthorised
        case .unknown(let error): self = .unknown(error)
        }
    }

}
