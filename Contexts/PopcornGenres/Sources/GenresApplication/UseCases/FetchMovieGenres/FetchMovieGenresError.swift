//
//  FetchMovieGenresError.swift
//  PopcornGenres
//
//  Created by Adam Young on 06/06/2025.
//

import Foundation
import GenresDomain

public enum FetchMovieGenresError: Error {

    case unauthorised
    case unknown(Error? = nil)

}

extension FetchMovieGenresError {

    init(_ error: GenreRepositoryError) {
        switch error {
        case .unauthorised: self = .unauthorised
        case .unknown(let error): self = .unknown(error)
        }
    }

}
