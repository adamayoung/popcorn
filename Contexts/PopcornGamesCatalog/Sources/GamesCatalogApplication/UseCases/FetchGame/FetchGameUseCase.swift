//
//  FetchGameUseCase.swift
//  PopcornGamesCatalog
//
//  Created by Adam Young on 09/12/2025.
//

import Foundation
import GamesCatalogDomain

public protocol FetchGameUseCase: Sendable {

    func execute(id: GameMetadata.ID) async throws(FetchGameError) -> GameMetadata

}
