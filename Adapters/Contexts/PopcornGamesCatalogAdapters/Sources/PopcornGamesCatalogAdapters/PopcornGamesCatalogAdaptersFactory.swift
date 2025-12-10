//
//  PopcornGamesCatalogAdaptersFactory.swift
//  PopcornGamesCatalogAdapters
//
//  Created by Adam Young on 26/11/2025.
//

import Foundation
import GamesCatalogApplication

struct PopcornGamesCatalogAdaptersFactory {

    func makeGamesCatalogFactory() -> GamesCatalogApplicationFactory {
        GamesCatalogComposition.makeGamesCatalogFactory()
    }

}
