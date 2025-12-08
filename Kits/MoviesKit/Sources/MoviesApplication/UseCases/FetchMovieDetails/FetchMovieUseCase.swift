//
//  FetchMovieDetailsUseCase.swift
//  MoviesKit
//
//  Created by Adam Young on 03/06/2025.
//

import Foundation

public protocol FetchMovieDetailsUseCase: Sendable {

    func execute(id: Int) async throws(FetchMovieDetailsError) -> MovieDetails

}
