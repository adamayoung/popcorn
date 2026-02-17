//
//  FetchGamesUseCase.swift
//  PopcornGamesCatalog
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GamesCatalogDomain

public protocol FetchGamesUseCase: Sendable {

    func execute() async throws(FetchGamesError) -> [GameMetadata]

}
