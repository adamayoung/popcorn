//
//  FetchTVSeriesGenresUseCase.swift
//  PopcornGenres
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GenresDomain

public protocol FetchTVSeriesGenresUseCase: Sendable {

    func execute() async throws(FetchTVSeriesGenresError) -> [Genre]

}
