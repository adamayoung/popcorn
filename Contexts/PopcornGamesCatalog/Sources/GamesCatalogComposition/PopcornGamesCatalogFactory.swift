//
//  PopcornGamesCatalogFactory.swift
//  PopcornGamesCatalog
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GamesCatalogApplication

public protocol PopcornGamesCatalogFactory: Sendable {

    func makeFetchGamesUseCase() -> FetchGamesUseCase

    func makeFetchGameUseCase() -> FetchGameUseCase

}
