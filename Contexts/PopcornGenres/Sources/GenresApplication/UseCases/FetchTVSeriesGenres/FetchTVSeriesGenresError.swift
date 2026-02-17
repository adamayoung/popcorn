//
//  FetchTVSeriesGenresError.swift
//  PopcornGenres
//
//  Copyright © 2026 Adam Young.
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
        case .unauthorised: self = .unauthorised
        case .unknown(let error): self = .unknown(error)
        }
    }

}
