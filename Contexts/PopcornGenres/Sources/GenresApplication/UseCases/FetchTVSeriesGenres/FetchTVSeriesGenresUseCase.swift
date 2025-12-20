//
//  FetchTVSeriesGenresUseCase.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresDomain

public protocol FetchTVSeriesGenresUseCase: Sendable {

    func execute() async throws(FetchTVSeriesGenresError) -> [Genre]

}
