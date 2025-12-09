//
//  FetchTVSeriesGenresUseCase.swift
//  PopcornGenres
//
//  Created by Adam Young on 06/06/2025.
//

import Foundation
import GenresDomain

public protocol FetchTVSeriesGenresUseCase: Sendable {

    func execute() async throws(FetchTVSeriesGenresError) -> [Genre]

}
