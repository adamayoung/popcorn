//
//  ToggleFavouriteMovieUseCase.swift
//  MoviesKit
//
//  Created by Adam Young on 03/12/2025.
//

import Foundation

public protocol ToggleFavouriteMovieUseCase: Sendable {

    func execute(id: Int) async throws(ToggleFavouriteMovieError)

}
