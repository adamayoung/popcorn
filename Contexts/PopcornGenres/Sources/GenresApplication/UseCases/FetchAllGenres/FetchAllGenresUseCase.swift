//
//  FetchAllGenresUseCase.swift
//  PopcornGenres
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol FetchAllGenresUseCase: Sendable {

    func execute() async throws(FetchAllGenresError) -> [GenreDetailsExtended]

}
