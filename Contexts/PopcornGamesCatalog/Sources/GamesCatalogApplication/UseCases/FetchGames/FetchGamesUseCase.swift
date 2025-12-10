//
//  FetchGamesUseCase.swift
//  PopcornGamesCatalog
//
//  Created by Adam Young on 09/12/2025.
//

import Foundation
import GamesCatalogDomain

public protocol FetchGamesUseCase: Sendable {

    func execute() async throws(FetchGamesError) -> [GameMetadata]

}
