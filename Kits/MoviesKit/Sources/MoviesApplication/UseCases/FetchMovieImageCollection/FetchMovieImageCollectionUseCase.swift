//
//  FetchMovieImageCollectionUseCase.swift
//  MoviesKit
//
//  Created by Adam Young on 24/11/2025.
//

import Foundation
import MoviesDomain

public protocol FetchMovieImageCollectionUseCase: Sendable {

    func execute(movieID: Movie.ID) async throws(FetchMovieImageCollectionError)
        -> ImageCollectionDetails

}
