//
//  PopcornGamesCatalogFactory.swift
//  PopcornGamesCatalog
//
//  Created by Adam Young on 08/01/2026.
//

import Foundation
import GamesCatalogApplication

public protocol PopcornGamesCatalogFactory: Sendable {

    func makeFetchGamesUseCase() -> FetchGamesUseCase

    func makeFetchGameUseCase() -> FetchGameUseCase

}
