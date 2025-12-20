//
//  FetchGamesUseCase.swift
//  PopcornGamesCatalog
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GamesCatalogDomain

public protocol FetchGamesUseCase: Sendable {

    func execute() async throws(FetchGamesError) -> [GameMetadata]

}
