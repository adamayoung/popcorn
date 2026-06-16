//
//  TVRegionEntity.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class TVRegionEntity: Equatable {

    var bouquet: Int
    var subBouquet: Int
    var name: String
    var nation: String
    var isHD: Bool

    init(bouquet: Int, subBouquet: Int, name: String, nation: String, isHD: Bool) {
        self.bouquet = bouquet
        self.subBouquet = subBouquet
        self.name = name
        self.nation = nation
        self.isHD = isHD
    }

}
