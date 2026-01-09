//
//  PopcornGamesCatalogFactory.swift
//  PopcornGamesCatalog
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GamesCatalogApplication

public protocol PopcornGamesCatalogFactory: Sendable {

    func makeFetchGamesUseCase() -> FetchGamesUseCase

    func makeFetchGameUseCase() -> FetchGameUseCase

}
