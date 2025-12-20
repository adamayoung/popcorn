//
//  FetchGameUseCase.swift
//  PopcornGamesCatalog
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GamesCatalogDomain

public protocol FetchGameUseCase: Sendable {

    func execute(id: GameMetadata.ID) async throws(FetchGameError) -> GameMetadata

}
